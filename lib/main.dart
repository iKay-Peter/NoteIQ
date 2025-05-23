import 'package:flutter/material.dart';
import 'package:notiq/app/config/app_routes.dart';
import 'package:notiq/app/config/route_generator.dart';
import 'package:notiq/app/theme/app_theme.dart';
import 'package:notiq/brick/repository.dart';
import 'package:sqflite/sqflite.dart' show databaseFactory;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

final navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  // Initialize FFI for desktop or test environments
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  await Repository.configure(databaseFactory);
  await Repository().initialize();
  await Repository().initialize();

  //TODO: setupDependencies(navigatorKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'NoteIQ',
      theme: Apptheme.lightTheme,
      initialRoute: AppRoutes.splash, // Or your initial route
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
