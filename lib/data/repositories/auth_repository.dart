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
}

class AuthImplementation implements AuthRepository {
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
        var signinResponse = await Supabase.instance.client.auth
            .signInWithPassword(email: email, password: password);
        print(signinResponse);
        await Supabase.instance.client.from('users').insert({
          'user_id': signinResponse.user!.id,
          'name': user.name,
          'email': user.email,
        });
        return GenericResponse(
          isSuccess: true,
          message: 'Registration Successful',
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
    } on PostgrestException catch (e) {
      print(e.toString());
      return GenericResponse(isSuccess: false, message: e.message);
    } catch (e) {
      return GenericResponse(isSuccess: false, message: 'Unexpected error: $e');
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
        return GenericResponse(isSuccess: true, message: 'Login Successful');
      } else {
        return GenericResponse(isSuccess: false, message: 'Login Failed');
      }
    } on AuthException catch (e) {
      print(e.toString());

      return GenericResponse(isSuccess: false, message: e.message);
    } on PostgrestException catch (e) {
      print(e.toString());
      return GenericResponse(isSuccess: false, message: e.message);
    } catch (e) {
      return GenericResponse(isSuccess: false, message: 'Unexpected error: $e');
    }
  }

  @override
  Future<GenericResponse<AppUser>> getUser(String email) async {
    try {
      final response =
          await Supabase.instance.client
              .from('users')
              .select()
              .eq('email', email)
              .single();
      final user = AppUser.fromJson(response);
      return GenericResponse(
        isSuccess: true,
        message: 'User fetched',
        data: user,
      );
    } on PostgrestException catch (e) {
      print(e.toString());
      return GenericResponse(isSuccess: false, message: e.message);
    } catch (e) {
      return GenericResponse(isSuccess: false, message: 'Unexpected error: $e');
    }
  }
}
