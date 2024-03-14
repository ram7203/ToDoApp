// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomTextInput extends StatefulWidget {
  final String labelText;
  final double fem;
  final double ffem;
  final TextEditingController? controller;
  final bool isPassword; // Add this variable
  final bool isEmail;
  bool? editable;
  bool? isPhone;

  CustomTextInput(
      {required this.labelText,
      required this.fem,
      required this.ffem,
      this.controller,
      this.isPassword = false,
      this.isPhone,
      this.editable,
      this.isEmail = false});

  @override
  _CustomTextInputState createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          22 * widget.fem, 14 * widget.fem, 22 * widget.fem, 13 * widget.fem),
      width: 277 * widget.fem,
      height: 47 * widget.fem,
      decoration: BoxDecoration(
        color: Color(0x59d9d9d9),
        borderRadius: BorderRadius.circular(14 * widget.fem),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              readOnly: (widget.editable == false) ? true : false,
              textInputAction: (widget.isPassword || widget.isEmail)
                  ? null
                  : TextInputAction.next,
              textCapitalization: (widget.isPassword || widget.isEmail)
                  ? TextCapitalization.none
                  : TextCapitalization.sentences,
              keyboardType: (widget.isPhone != null)
                  ? TextInputType.number
                  : TextInputType.text,
              onSubmitted: (value) {
                print("Text $value");
              },
              controller: widget.controller,
              decoration: InputDecoration.collapsed(
                hintText: widget.labelText,
              ),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16 * widget.ffem,
                fontWeight: FontWeight.w400,
                height: 1.2125 * widget.ffem / widget.fem,
                color: Color(0x7f000000),
              ),
              obscureText: widget.isPassword
                  ? !_showPassword
                  : false, // Obfuscate the text for password field
            ),
          ),
          // Show/hide password toggle button for password field only
          if (widget.isPassword)
            Stack(
              children: [
                IconButton(
                  padding: EdgeInsets.only(left: 30 * widget.fem),
                  icon: Icon(
                    _showPassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                ),
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
