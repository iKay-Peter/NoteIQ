import 'package:flutter/material.dart';
import 'package:notiq/app/config/app_routes.dart';
import 'package:notiq/app/config/route_generator.dart';
import 'package:notiq/app/theme/app_theme.dart';
import 'package:notiq/brick/repository.dart';
import 'package:sqflite/sqflite.dart' show databaseFactory;

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  await Repository.configure(databaseFactory);
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
