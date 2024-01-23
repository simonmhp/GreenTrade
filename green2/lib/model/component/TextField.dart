import 'package:flutter/material.dart';
import 'ColorGlobal.dart';

class TextFieldWidget extends StatelessWidget {
  final String hintText;
  final IconData prefixIconData;
  final bool obscureText;
  final TextEditingController textEditingController;
  final int? maxLines;
  final TextInputType keyboardType;
  final String? Function(String?)? validator; // Add validator property

  TextFieldWidget({
    required this.hintText,
    required this.prefixIconData,
    required this.obscureText,
    required this.textEditingController,
    this.maxLines,
    this.keyboardType = TextInputType.text,
    this.validator, // Include validator in the constructor
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      controller: textEditingController,
      cursorColor: ColorGlobal.colorPrimary,
      style: TextStyle(
        color: const Color.fromARGB(255, 0, 0, 0),
        fontWeight: FontWeight.w400,
        fontSize: 14.0,
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Color.fromARGB(255, 19, 173, 24)),
        focusColor: Color.fromARGB(255, 255, 255, 255),
        filled: true,
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: const Color.fromARGB(255, 49, 205, 54)),
        ),
        labelText: hintText,
        hintStyle: TextStyle(color: ColorGlobal.colorPrimary, fontSize: 14),
        prefixIcon: Icon(
          prefixIconData,
          size: 20,
          color: Color.fromARGB(255, 252, 0, 0),
        ),
      ),
      validator: validator, // Set the validator function
    );
  }
}
