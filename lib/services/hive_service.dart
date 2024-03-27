import 'package:hive_flutter/hive_flutter.dart';
import '/models/employee_model.dart';

class HiveService {
  static const String _employeesBoxName = 'employees';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(EmployeeAdapter());
    await Hive.openBox<Employee>(_employeesBoxName);
  }

  static Box<Employee> getEmployeesBox() {
    return Hive.box<Employee>(_employeesBoxName);
  }
}