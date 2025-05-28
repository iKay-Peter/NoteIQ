import 'package:brick_core/core.dart';
import 'package:notiq/app/exception_handler/app_exceptions.dart';
import 'package:notiq/app/utils/generic_response.dart';
import 'package:notiq/brick/repository.dart';
import 'package:notiq/models/appuser.model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  Future<GenericResponse<AuthResponse>> signUp(
    String email,
    String password,
    AppUser user,
  );
  Future<GenericResponse<AuthResponse>> login(String email, String password);

  Future<GenericResponse<AppUser>> getUser(String email);
  Future<GenericResponse<AppUser>> getCurrentUser();
}

class AuthImplementation implements AuthRepository {
  final Repository _repository;

  AuthImplementation(this._repository);

  @override
  Future<GenericResponse<AuthResponse>> signUp(
    String email,
    String password,
    AppUser user,
  ) async {
    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // Sign in and store user data using Brick
        var signinResponse = await Supabase.instance.client.auth
            .signInWithPassword(email: email, password: password);

        // Store user in Brick repository
        await _repository.upsert<AppUser>(
          AppUser(
            email: email,
            name: user.name,
            user_id: signinResponse.user!.id,
          ),
        );

        return GenericResponse(
          isSuccess: true,
          message: 'Registration Successful',
          data: response,
        );
      } else {
        return GenericResponse(
          isSuccess: false,
          message: 'Registration Failed',
        );
      }
    } on AuthException catch (e) {
      print(e.toString());
      return GenericResponse(isSuccess: false, message: e.message);
    } catch (e) {
      // Store offline if network error
      try {
        await _repository.upsert<AppUser>(user);
        return GenericResponse(
          isSuccess: true,
          message: 'Stored offline. Will sync when online.',
        );
      } catch (storageError) {
        return GenericResponse(
          isSuccess: false,
          message: 'Failed to store offline: $storageError',
        );
      }
    }
  }

  @override
  Future<GenericResponse<AuthResponse>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        if (!response.user!.confirmedAt.toString().isNotEmpty) {
          throw NotConfirmedException('Please confirm your account to login.');
        }

        // Fetch and store user data in local repository
        final userData = await getUser(email);
        if (userData.isSuccess) {
          await _repository.upsert<AppUser>(userData.data!);
        }

        return GenericResponse(
          isSuccess: true,
          message: 'Login Successful',
          data: response,
        );
      } else {
        return GenericResponse(isSuccess: false, message: 'Login Failed');
      }
    } on AuthException catch (e) {
      print(e.toString());
      return GenericResponse(isSuccess: false, message: e.message);
    } catch (e) {
      return GenericResponse(isSuccess: false, message: 'Unexpected error: $e');
    }
  }

  @override
  Future<GenericResponse<AppUser>> getUser(String email) async {
    try {
      // Try to get user from local storage first
      final users = await _repository.get<AppUser>(
        query: Query.where('email', email),
      );

      if (users.isNotEmpty) {
        return GenericResponse(
          isSuccess: true,
          message: 'User fetched from local storage',
          data: users.first,
        );
      }

      // If not in local storage, try to fetch from Supabase
      final response = await Supabase.instance.client
          .from('users')
          .select()
          .eq('email', email)
          .single();

      final user = AppUser.fromJson(response);

      // Store in local repository
      await _repository.upsert<AppUser>(user);

      return GenericResponse(
        isSuccess: true,
        message: 'User fetched',
        data: user,
      );
    } catch (e) {
      return GenericResponse(isSuccess: false, message: 'Unexpected error: $e');
    }
  }

  @override
  Future<GenericResponse<AppUser>> getCurrentUser() async {
    try {
      // Try to get the last logged-in user from local storage first
      final users = await _repository.get<AppUser>();
      if (users.isNotEmpty) {
        // Optionally, you could filter for the most recently used user
        return GenericResponse(
          isSuccess: true,
          message: 'User fetched from local storage',
          data: users.first,
        );
      }

      // If not found locally, try to get from Supabase (online)
      final currentUser = Supabase.instance.client.auth.currentUser;
      if (currentUser == null) {
        return GenericResponse(
          isSuccess: false,
          message: 'No user is currently logged in',
        );
      }

      return await getUser(currentUser.email!);
    } catch (e) {
      return GenericResponse(
        isSuccess: false,
        message: 'Failed to get current user: $e',
      );
    }
  }
}
