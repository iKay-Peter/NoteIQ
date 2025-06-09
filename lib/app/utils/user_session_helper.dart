import 'package:notiq/models/appuser.model.dart';

class UserSession {
  static final UserSession _instance = UserSession._internal();
  factory UserSession() => _instance;

  UserSession._internal();

  AppUser? user;
  final Map<String, dynamic> _preferences = {};

  void setUser(AppUser user) {
    this.user = user;
  }

  AppUser? get getUser => user;

  String? getString(String key) {
    return _preferences[key]?.toString();
  }
}
