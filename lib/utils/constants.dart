// In lib/utils/constants.dart
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class AppConstants extends ChangeNotifier {
  static const String _fixedSalaryBoxName = 'settings';
  static const String _fixedSalaryKey = 'fixed_salary';

  static int _fixedSalary = 250; // Default value

  static int get fixedSalary => _fixedSalary;

  static Future<void> init() async {
    // Open or create the settings box
    final settingsBox = await Hive.openBox(_fixedSalaryBoxName);

    // Load the saved fixed salary or use default
    _fixedSalary = settingsBox.get(_fixedSalaryKey, defaultValue: 250);
  }

  static Future<void> updateFixedSalary(int newValue) async {
    _fixedSalary = newValue;

    // Save to Hive
    final settingsBox = await Hive.openBox(_fixedSalaryBoxName);
    await settingsBox.put(_fixedSalaryKey, newValue);
  }
}
