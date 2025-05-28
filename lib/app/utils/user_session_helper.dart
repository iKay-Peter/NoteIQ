import 'package:notiq/models/appuser.model.dart';

class UserSession {
  static final UserSession _instance = UserSession._internal();
  factory UserSession() => _instance;

  UserSession._internal();

  AppUser? user;

  void setUser(AppUser user) {
    this.user = user;
  }

  AppUser? get getUser => user;
}
