// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final double fem;
  final double ffem;
  final List<Color> gradientColors;
  bool? loginPressed;

  GradientButton({
    required this.onPressed,
    required this.buttonText,
    required this.fem,
    required this.ffem,
    required this.gradientColors,
    this.loginPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50 * fem),
        ),
        elevation: 8 * fem,
        primary: Colors.transparent,
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50 * fem),
          gradient: LinearGradient(
            colors: gradientColors,
            stops: [0, 1],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Container(
          // width: 180 * fem,
          height: 50 * fem,
          constraints: BoxConstraints(minHeight: 49 * fem),
          alignment: Alignment.center,
          child: (loginPressed == null || !loginPressed!)
              ? Text(
                  buttonText,
                  style: TextStyle(
                    fontFamily: 'Work Sans',
                    fontSize: 20 * ffem,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
