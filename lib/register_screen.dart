// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/login_screen.dart';
import 'package:todo/utils/snackbar.dart';
import 'package:todo/widgets/custom_button.dart';
import 'package:todo/widgets/custom_text_field.dart';
import 'package:vibration/vibration.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    bool registerPressed = false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50),
              Image.asset(
                'assets/images/logo.png',
                height: 200,
              ),
              const SizedBox(height: 100),
              CustomTextInput(
                labelText: 'Email ID',
                fem: fem,
                ffem: ffem,
                controller: _emailController,
                isEmail: true,
              ),
              const SizedBox(height: 16),
              CustomTextInput(
                labelText: 'Password',
                fem: fem,
                ffem: ffem,
                isPassword: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 16),
              CustomTextInput(
                labelText: 'Confirm Password',
                fem: fem,
                ffem: ffem,
                isPassword: true,
                controller: _confirmPasswordController,
              ),
              const SizedBox(height: 16),
              GradientButton(
                buttonText: 'REGISTER',
                loginPressed: registerPressed,
                fem: fem,
                ffem: ffem,
                gradientColors: [
                  Colors.greenAccent.shade200,
                  Colors.greenAccent.shade400
                ],
                onPressed: () async {
                  try {
                    Vibration.vibrate(duration: 100);
                  } catch (e) {
                    print("Vibrator error");
                  }

                  setState(() {
                    registerPressed = true;
                  });

                  String email = _emailController.text.toString();
                  String password = _passwordController.text.toString();
                  String confirmPassword =
                      _confirmPasswordController.text.toString();

                  if (email == '' || password == '' || confirmPassword == '') {
                    SnackbarHelper.showMessage(context, "All Fields Required");
                  } else if (validateEmail(email) == false) {
                    SnackbarHelper.showMessage(context, "Invalid Email Format");
                  } else if (password.length < 8) {
                    SnackbarHelper.showMessage(
                        context, "Password must be at least 8 characters");
                  } else if (password != confirmPassword) {
                    SnackbarHelper.showMessage(
                        context, "Passwords do not match");
                  } else {
                    try {
                      await _auth.createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      SnackbarHelper.showMessage(
                          context, "Registration Successful!");
                      Navigator.pop(context);
                    } catch (e) {
                      SnackbarHelper.showMessage(
                          context, "Registration Failed! $e");
                    }
                  }

                  print('Registration submitted!');
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Go back to the login screen
                },
                child: const Text('Already have an account? Login Here'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
