import '/models/employee_model.dart';
import '/services/hive_service.dart';
import '/utils/constants.dart';

class EmployeeRepository {
  final employeesBox = HiveService.getEmployeesBox();

  List<Employee> getAllEmployees() {
    return employeesBox.values.toList();
  }

  Future<void> addEmployee(Employee employee) async {
    await employeesBox.add(employee);
  }

  Future<void> updateEmployee(Employee employee) async {
    await employee.save();
  }

  Future<void> deleteEmployee(Employee employee) async {
    await employee.delete();
  }

  int getEmployeeCount() {
    return employeesBox.length;
  }

  Future<void> updateWorkingDayStatus(
    Employee employee,
    int index,
    bool isPaid,
  ) async {
    employee.workingDaysList[index].isPaid = isPaid;
    await employee.save();
  }

  int calculatePaidAmount(Employee employee) {
    return employee.workingDaysList.where((day) => day.isPaid).length *
        AppConstants.fixedSalary;
  }

  int calculateRemainingAmount(Employee employee) {
    return employee.totalAmount - calculatePaidAmount(employee);
  }
}
