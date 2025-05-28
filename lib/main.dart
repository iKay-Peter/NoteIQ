import 'package:flutter/material.dart';
import 'package:notiq/app/config/get_it.dart';
import 'package:notiq/app/config/routes/app_routes.dart';
import 'package:notiq/app/config/routes/route_generator.dart';
import 'package:notiq/app/theme/app_theme.dart';
import 'package:notiq/brick/repository.dart';
import 'package:notiq/data/providers/registration_provider.dart';
import 'package:notiq/data/providers/task_provider.dart';
import 'package:notiq/data/repositories/auth_repository.dart';
import 'package:notiq/data/repositories/task_repository.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart' show databaseFactory;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

final navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  await Repository.configure(databaseFactory);
  await Repository().initialize();

  setupDependencies(navigatorKey);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => RegistrationProvider(getIt<AuthRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) => TaskProvider(getIt<TaskRepository>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'NotifIQ',
      theme: Apptheme.lightTheme,
      initialRoute: AppRoutes.splash, // Or your initial route
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
