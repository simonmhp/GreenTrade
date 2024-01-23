import 'package:flutter/material.dart';
import 'ColorGlobal.dart';

class DropdownWidget extends StatelessWidget {
  final String hintText;
  final IconData prefixIconData;
  final List<String> dropdownItems;
  final String? selectedValue;
  final void Function(String?)? onChanged;
  final double? width; // Add the width parameter

  DropdownWidget({
    required this.hintText,
    required this.prefixIconData,
    required this.dropdownItems,
    required this.selectedValue,
    required this.onChanged,
    this.width, // Include width in the constructor
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      onChanged: onChanged,
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
      items: dropdownItems.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      // Apply width to the dropdown field
      isExpanded:
          width == null, // Allow the dropdown to expand if width is null
      dropdownColor: Colors.white, // Customize dropdown background color
      style: TextStyle(
        color: Colors.black, // Customize dropdown text color
      ),
      iconSize: 30.0, // Customize dropdown arrow icon size
      elevation: 8, // Customize the elevation of the dropdown
      icon: Icon(Icons.arrow_drop_down), // Customize dropdown arrow icon
      hint: Text(
        hintText,
        style: TextStyle(
          color: Colors.black54, // Customize hint text color
        ),
      ),
      itemHeight: null, // Allow Flutter to determine item height
      // underline: Container(), // Remove the default underline
    );
  }
}
