import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:notiq/data/repositories/auth_repository.dart';

final getIt = GetIt.instance;

void setupDependencies(GlobalKey<NavigatorState> navigatorKey) {
  getIt.registerSingleton<AuthRepository>(AuthImplementation());
}
