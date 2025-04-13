// ignore_for_file: unused_element

import 'package:flutter/material.dart';

// Define color constants
const Color primaryColor = Color(0xFF4CAF50); // Green color
const Color primaryColorLight = Color.fromARGB(
  255,
  101,
  169,
  23,
); // Light shade of green
const Color primaryColorDark = Color(0xFF388E3C); // Dark shade of green
const Color secondaryColor = Color.fromARGB(255, 158, 158, 158); // grey color

// Define color variables
const Color _primaryColor = primaryColor;
const Color _primaryColorLight = primaryColorLight;
const Color _primaryColorDark = primaryColorDark;
const Color _secondaryColor = secondaryColor;

// app's theme
final appTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    backgroundColor: _primaryColor,
    foregroundColor: Colors.white,
  ),
);
