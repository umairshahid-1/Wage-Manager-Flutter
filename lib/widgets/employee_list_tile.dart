import 'dart:io';
import 'package:flutter/material.dart';
import '../screens/employee_details_screen.dart';
// import '/models/employee.dart' as original_employee;
import '/models/employee_model.dart';

class EmployeeListTile extends StatelessWidget {
  final Employee employee;
  final Function(Employee) updateEmployee;

  const EmployeeListTile({
    super.key,
    required this.employee,
    required this.updateEmployee,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: employee.imagePath != null
            ? FileImage(File(employee.imagePath!))
            : const AssetImage('assets/images/placeholder.png')
                as ImageProvider,
      ),
      title: Text(employee.name),
      subtitle: Text('Working Days: ${employee.workingDays}'),
      trailing: Text('Total Amount: ${employee.totalAmount}'),
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return EmployeeDetailsScreen(
              employee: employee,
              updateEmployee: updateEmployee,
            );
          },
        );
      },
    );
  }
}
