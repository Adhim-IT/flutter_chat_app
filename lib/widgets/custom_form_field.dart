import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import FontAwesomeIcons

class CustomFormField extends StatelessWidget {
  final String hintText;
  final double height;
  final RegExp validationRegEx;
  final bool obscureText;
  final void Function(String?) onSaved;
  final Widget? suffixIcon; // New property for suffix icon

  const CustomFormField({
    Key? key, // Add key parameter here
    required this.hintText,
    required this.height,
    required this.validationRegEx,
    required this.onSaved,
    this.obscureText = false,
    this.suffixIcon, // Initialize suffixIcon property
  }) : super(key: key); // Pass key to super constructor

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        obscureText: obscureText,
        onSaved: onSaved,
        validator: (value) {
          if (value != null && validationRegEx.hasMatch(value)) {
            return null;
          }
          return "Enter a valid ${hintText.toLowerCase()}";
        },
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(),
          suffixIcon: suffixIcon, 
          prefixIcon: hintText == "Email"
              ? const Icon(Icons.email)
              : hintText == "Password"
                  ? const  Icon(Icons.lock)
                  : hintText == "Name"
                      ? const Icon(FontAwesomeIcons.user)
                      : null,
        ),
      ),
    );
  }
}
