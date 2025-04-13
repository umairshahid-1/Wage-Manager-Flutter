import 'package:flutter/material.dart';
import '/utils/theme.dart';

class ReusableTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final TextInputAction textInputAction;

  const ReusableTextField({
    super.key,
    required this.labelText,
    required this.controller,
    required this.keyboardType,
    required this.textInputAction,
    this.validator,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: const TextStyle(fontWeight: FontWeight.w500),
      cursorColor: primaryColorLight,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon:
            prefixIcon != null
                ? Icon(prefixIcon, color: primaryColorLight)
                : null,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: primaryColorLight,
        ),
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: primaryColorLight),
        ),
      ),
      validator: validator,
    );
  }
}
