import 'package:flutter/material.dart';
import 'package:notiq/app/config/routes/app_routes.dart';
import 'package:notiq/ui/layouts/home_layout.dart';
import 'package:notiq/ui/screens/all_tasks_screen.dart';
import 'package:notiq/ui/screens/login_screen.dart';
import 'package:notiq/ui/screens/offline_screen.dart';
import 'package:notiq/ui/screens/register_screen.dart';
import 'package:notiq/ui/screens/splash_screen.dart';
import 'package:notiq/ui/screens/tasks_page.dart';
import 'package:notiq/ui/screens/welcome.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => HomeLayout());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case AppRoutes.welcome:
        return MaterialPageRoute(builder: (_) => Welcome());
      case AppRoutes.task:
        return MaterialPageRoute(builder: (_) => TasksPage());
      case AppRoutes.allTasks:
        return MaterialPageRoute(builder: (_) => AllTasksScreen());
      case AppRoutes.networkError:
        return MaterialPageRoute(builder: (_) => OfflineScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: const Center(child: Text('Page not found')),
        );
      },
    );
  }
}
