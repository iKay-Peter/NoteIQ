import 'package:flutter/material.dart';
import 'package:notiq/app/exception_handler/app_exceptions.dart';
import 'package:notiq/app/utils/generic_response.dart';
import 'package:notiq/app/utils/user_session_helper.dart';
import 'package:notiq/data/repositories/auth_repository.dart';
import 'package:notiq/models/appuser.model.dart';

class RegistrationProvider with ChangeNotifier {
  final AuthRepository _authRepository;

  RegistrationProvider(this._authRepository);

  //VARIABLE
  bool _isLoading = false;
  String _email = '';
  late AppUser _user;
  String _password = '';

  //GETTERS
  bool get isLoading => _isLoading;
  String get email => _email;
  AppUser get user => _user;
  String get password => _password;

  //SETTERS
  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setUser(AppUser user) {
    _user = user;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  //ACTIONS
  Future<GenericResponse> register() async {
    _isLoading = true;
    notifyListeners();

    try {
      var response = await _authRepository.signUp(_email, _password, _user);
      return response;
    } catch (error) {
      return GenericResponse(isSuccess: false, message: error.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<GenericResponse> login() async {
    _isLoading = true;
    notifyListeners();

    try {
      var response = await _authRepository.login(email, password);
      if (response.isSuccess) {
        var getUserResponse = await _authRepository.getUser(email);
        if (getUserResponse.isSuccess) {
          _user = getUserResponse.data!;
          UserSession().setUser(_user);
        }
      }
      return response;
    } on NotConfirmedException {
      rethrow;
    } catch (error) {
      return GenericResponse(isSuccess: false, message: error.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<GenericResponse> checkAuthState() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(Durations.extralong4);

    try {
      // Check Brick local storage first
      final users = await _authRepository.getCurrentUser();
      if (users.data != null) {
        // User exists locally, navigate to home
        _user = users.data!;
        UserSession().setUser(_user);
      }
      return GenericResponse(
        isSuccess: users.isSuccess,
        message: users.message,
      );
    } catch (e) {
      print('Error checking auth state: $e');
      return GenericResponse(isSuccess: false, message: e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
