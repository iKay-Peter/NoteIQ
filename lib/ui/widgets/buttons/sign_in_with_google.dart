import 'package:flutter/material.dart';

class SignInWithGoogleButton extends StatelessWidget {
  const SignInWithGoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: Image.asset(
          'assets/images/logos/google.png',
          height: 24,
          width: 24,
        ),
        label: Text(
          "Sign in with Google",
          style: Theme.of(
            context,
          ).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w600),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.grey),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          foregroundColor: Colors.black87,
          backgroundColor: Colors.white,
        ),
        onPressed: () {
          // TODO: Implement Google sign-in logic
        },
      ),
    );
  }
}
