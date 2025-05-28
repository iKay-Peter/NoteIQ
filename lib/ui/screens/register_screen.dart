import 'package:flutter/material.dart';
import 'package:notiq/app/utils/action_handler.dart';
import 'package:notiq/data/providers/registration_provider.dart';
import 'package:notiq/models/appuser.model.dart';
import 'package:provider/provider.dart';
import 'package:notiq/ui/widgets/buttons/sign_in_with_google.dart';
import 'package:notiq/ui/widgets/buttons/submit_button.dart';
import 'package:notiq/ui/widgets/input/text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>(); // Add a form key
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Consumer<RegistrationProvider>(
            builder: (context, provider, _) => Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              child: const Icon(Icons.arrow_back),
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/illustrations/signup.png',
                              height: 180,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text("Register", style: theme.textTheme.titleLarge),
                    Text(
                      "Create a new account",
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      label: "Full name",
                      hintText: "John Doe",
                      keyboardType: TextInputType.text,
                      prefixIcon: Icons.person_2_outlined,
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      label: "Your Email",
                      hintText: "example@gmail.com",
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@') && !value.contains('.')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      label: "Password",
                      hintText: "• • • • • • • • • • •",
                      obscureText: true,
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        if (!RegExp(r'[a-z]').hasMatch(value)) {
                          return 'Password must contain at least one lowercase letter';
                        }
                        if (!RegExp(r'[A-Z]').hasMatch(value)) {
                          return 'Password must contain at least one uppercase letter';
                        }
                        if (!RegExp(r'[0-9]').hasMatch(value)) {
                          return 'Password must contain at least one digit';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    SubmitButton(
                      text: 'Register',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          provider.setUser(
                            AppUser(
                              email: _emailController.text.trim(),
                              name: _nameController.text.trim(),
                            ),
                          );
                          provider.setEmail(_emailController.text.trim());
                          provider.setPassword(_passwordController.text.trim());
                          if (!provider.isLoading) {
                            handleAction(
                              context: context,
                              call: provider.register,
                              onSuccess: (data) => Navigator.of(context).pop(),
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
                          child: Text("or", style: theme.textTheme.labelSmall),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SignInWithGoogleButton(),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Already have an Account?",
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
    );
  }
}
