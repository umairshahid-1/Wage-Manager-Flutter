import 'package:flutter/foundation.dart';
import '/models/employee_model.dart';
import '/repositories/employee_repository.dart';
import '/utils/constants.dart';

class EmployeeProvider extends ChangeNotifier {
  final EmployeeRepository _repository = EmployeeRepository();

  List<Employee> get employees => _repository.getAllEmployees();

  Future<void> addEmployee(Employee employee) async {
    await _repository.addEmployee(employee);
    notifyListeners();
  }

  Future<void> updateEmployee(Employee employee) async {
    await _repository.updateEmployee(employee);
    notifyListeners();
  }

  Future<void> deleteEmployee(Employee employee) async {
    await _repository.deleteEmployee(employee);
    notifyListeners();
  }

  Future<void> toggleWorkingDayPaidStatus(Employee employee, int index) async {
    bool newStatus = !employee.workingDaysList[index].isPaid;
    await _repository.updateWorkingDayStatus(employee, index, newStatus);

    // Update calculated fields
    employee.amountReceived = _repository.calculatePaidAmount(employee);

    notifyListeners();
  }

  Future<void> addWorkingDay(Employee employee, DateTime date) async {
    employee.workingDaysList.add(WorkingDay(date: date));
    employee.workingDays = employee.workingDaysList.length;
    employee.totalAmount = employee.workingDays * AppConstants.fixedSalary;
    await _repository.updateEmployee(employee);
    notifyListeners();
  }

  Future<void> removeWorkingDay(Employee employee, int index) async {
    employee.workingDaysList.removeAt(index);
    employee.workingDays = employee.workingDaysList.length;
    employee.totalAmount = employee.workingDays * AppConstants.fixedSalary;
    employee.amountReceived = _repository.calculatePaidAmount(employee);
    await _repository.updateEmployee(employee);
    notifyListeners();
  }

  Future<void> deleteMultipleEmployees(List<Employee> employees) async {
    for (var employee in employees) {
      await _repository.deleteEmployee(employee);
    }
    notifyListeners();
  }
}
