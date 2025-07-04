import 'package:flutter/material.dart';
import 'package:notiq/app/config/routes/app_routes.dart';
import 'package:notiq/app/utils/action_handler.dart';
import 'package:notiq/data/providers/registration_provider.dart';
import 'package:notiq/ui/widgets/buttons/sign_in_with_google.dart';
import 'package:notiq/ui/widgets/buttons/submit_button.dart';
import 'package:notiq/ui/widgets/input/text_field.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Add a form key
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<RegistrationProvider>(
        builder: (context, provider, child) => Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/illustrations/login.png',
                            height: 200,
                          ),
                        ],
                      ),
                      Text("Login", style: theme.textTheme.titleLarge),
                      Text(
                        "Sign in to your account",
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        label: "Your Email",
                        controller: _emailController,
                        hintText: "example@gmail.com",
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email_outlined,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: _passwordController,
                        label: "Password",
                        hintText: "• • • • • • • • • • •",
                        obscureText: true,
                        prefixIcon: Icons.lock_outline,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              "Forgot Password?",
                              style: theme.textTheme.labelSmall,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SubmitButton(
                        text: 'Login',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            provider.setEmail(_emailController.text.trim());
                            provider.setPassword(
                              _passwordController.text.trim(),
                            );
                            if (!provider.isLoading) {
                              handleAction(
                                context: context,
                                call: provider.login,
                                onSuccess: (data) =>
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      AppRoutes.home,
                                      (route) => false,
                                    ),
                              );
                            }
                          }
                        },
                        isLoading: provider.isLoading,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "or",
                              style: theme.textTheme.labelSmall,
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SignInWithGoogleButton(),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.register);
                            },
                            child: Text(
                              "Don't have an Account?",
                              style: theme.textTheme.labelSmall,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
