import 'package:flutter/material.dart';
import 'package:notiq/app/config/app_routes.dart';
import 'package:notiq/app/theme/app_theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

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
              'NotIQ',
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

            //TODO: CircularProgressIndicator(
            //   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            // ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to the home screen
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Apptheme.orange,
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              icon: Icon(Icons.arrow_forward, color: Apptheme.orange, size: 25),
              label: Text(
                'Get Started',
                style: theme.textTheme.titleMedium!.copyWith(
                  color: Apptheme.orange,
                  fontSize: 16,
                ),
              ),
              iconAlignment: IconAlignment.end,
            ),
          ],
        ),
      ),
    );
  }
}
