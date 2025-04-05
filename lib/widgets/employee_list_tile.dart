import 'dart:io';
import 'package:flutter/material.dart';
import '../screens/employee_details.dart';
import '../utils/theme.dart';
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
            : null,
        backgroundColor: Colors.grey.shade200,
        child: employee.imagePath == null
            ? const Icon(
                Icons.person_2,
                size: 30.0,
                color: primaryColorDark,
              )
            : null,
      ),
      title: Text(employee.name),
      subtitle: Text('Working Days: ${employee.workingDays}'),
      trailing: Text('Total Amount: ${employee.totalAmount}'),
      onTap: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: EmployeeDetailsScreen(
                employee: employee,
                updateEmployee: updateEmployee,
              ),
            );
          },
        );
      },
    );
  }
}
