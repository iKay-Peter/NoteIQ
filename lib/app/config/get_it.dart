import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:notiq/brick/repository.dart';
import 'package:notiq/data/repositories/auth_repository.dart';
import 'package:notiq/data/repositories/task_repository.dart';

final getIt = GetIt.instance;

void setupDependencies(GlobalKey<NavigatorState> navigatorKey) {
  getIt.registerSingleton<Repository>(Repository());
  getIt.registerSingleton<AuthRepository>(
    AuthImplementation(getIt<Repository>()),
  );
  getIt.registerSingleton<TaskRepository>(
    TaskImplementation(getIt<Repository>()),
  );
}
