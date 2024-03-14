// ignore_for_file: curly_braces_in_flow_control_structures, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/home_screen.dart';
import 'package:todo/register_screen.dart';
import 'package:todo/utils/snackbar.dart';
import 'package:todo/widgets/custom_button.dart';
import 'package:todo/widgets/custom_text_field.dart';
import 'package:vibration/vibration.dart';

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    bool loginPressed = false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Add the logo image
              const SizedBox(height: 50),
              Image.asset(
                'assets/images/logo.png', // Replace 'your_logo.png' with your actual logo image file
                height: 200, // Adjust the height as needed
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
              GradientButton(
                buttonText: 'LOGIN',
                loginPressed: loginPressed,
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
                    loginPressed = true;
                  });

                  bool x = validateEmail("raghuramvasco@gmail.com");
                  String email = _emailController.text.toString();
                  String password = _passwordController.text.toString();
                  print("Boolean: $x");
                  if (email == '' || password == '') {
                    SnackbarHelper.showMessage(context, "All Fields Required");
                  } else if (validateEmail(email) == false)
                    SnackbarHelper.showMessage(context, "Invalid Email Format");
                  else if (password.length < 8)
                    SnackbarHelper.showMessage(
                        context, "Password must be atleast 8 characters");
                  else {
                    try {
                      await _auth.signInWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                      SnackbarHelper.showMessage(
                          context, "Login in Successful!");
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(email: email),
                        ),
                      );
                    } catch (e) {
                      SnackbarHelper.showMessage(
                          context, "Login in Failed! $e");
                    }
                  }
                  // setState(() {
                  //   loginPressed = false;
                  // });
                  print(_emailController.text);
                  print('Login submitted!');
                },
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegistrationScreen(),
                    ),
                  );
                },
                child: const Text('New User? Register Here'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    await _auth.sendPasswordResetEmail(
                        email: _emailController.text);
                    SnackbarHelper.showMessage(
                        context, "Password reset email sent");
                  } catch (e) {
                    SnackbarHelper.showMessage(
                        context, "Password reset error! $e");
                  }
                },
                child: const Text('Forgot Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

bool validateEmail(String email) {
  // Regular expression pattern to validate email addresses
  final RegExp emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  // Check if the email matches the pattern
  return emailRegex.hasMatch(email);
}
