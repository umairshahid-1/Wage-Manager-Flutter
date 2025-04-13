import 'package:hive_flutter/hive_flutter.dart';
import '/models/employee_model.dart';
import '/utils/constants.dart';

class HiveService {
  static const String _employeesBoxName = 'employees';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(EmployeeAdapter());
    Hive.registerAdapter(WorkingDayAdapter());
    await Hive.openBox<Employee>(_employeesBoxName);

    // Initialize AppConstants
    await AppConstants.init();
  }

  static Box<Employee> getEmployeesBox() {
    return Hive.box<Employee>(_employeesBoxName);
  }
}