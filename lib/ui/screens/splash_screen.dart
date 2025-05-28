import 'package:flutter/material.dart';
import 'package:notiq/app/config/routes/app_routes.dart';
import 'package:notiq/app/theme/app_theme.dart';
import 'package:notiq/app/utils/action_handler.dart';
import 'package:notiq/data/providers/registration_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthState();
    });
  }

  Future<void> _checkAuthState() async {
    handleAction(
      context: context,
      call: Provider.of<RegistrationProvider>(
        context,
        listen: false,
      ).checkAuthState,
      showSuccessNotification: false,
      showErrorNotification: false,
      onSuccess: (data) =>
          Navigator.pushReplacementNamed(context, AppRoutes.home),
      onError: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Apptheme.orange,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_active, size: 80, color: Colors.white),
            const SizedBox(height: 24),
            Text(
              'NotifIQ',
              style: theme.textTheme.titleLarge!.copyWith(
                fontSize: 40,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Your smart notification manager',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 48),

            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
