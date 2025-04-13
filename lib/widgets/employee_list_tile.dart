import 'dart:io';
import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '/models/employee_model.dart';

class EmployeeListTile extends StatelessWidget {
  final Employee employee;
  final Function(Employee) updateEmployee;
  final bool isSelected;
  final bool selectionMode;

  const EmployeeListTile({
    super.key,
    required this.employee,
    required this.updateEmployee,
    this.isSelected = false,
    this.selectionMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            backgroundImage:
                employee.imagePath != null
                    ? FileImage(File(employee.imagePath!))
                    : null,
            backgroundColor: Colors.grey.shade200,
            child:
                employee.imagePath == null
                    ? const Icon(
                      Icons.person_2,
                      size: 30.0,
                      color: primaryColorDark,
                    )
                    : null,
          ),
          if (selectionMode)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor : Colors.grey,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(
                  isSelected ? Icons.check : null,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
      title: Text(employee.name),
      subtitle: Text('Working Days: ${employee.workingDays}'),
      trailing: Text('Total Amount: ${employee.totalAmount}'),
    );
  }
}