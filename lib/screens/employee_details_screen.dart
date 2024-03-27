import 'dart:io';
import 'package:flutter/material.dart';
// import '/models/employee.dart' as original_employee;
import '/utils/constants.dart';
import '/models/employee_model.dart';

class EmployeeDetailsScreen extends StatefulWidget {
  final Employee employee;
  final Function(Employee) updateEmployee;

  const EmployeeDetailsScreen({
    super.key,
    required this.employee,
    required this.updateEmployee,
  });

  @override
  // ignore: library_private_types_in_public_api
  _EmployeeDetailsScreenState createState() => _EmployeeDetailsScreenState();
}

class _EmployeeDetailsScreenState extends State<EmployeeDetailsScreen> {
  late Employee _employee;

  @override
  void initState() {
    super.initState();
    _employee = Employee(
      id: widget.employee.id,
      name: widget.employee.name,
      workingDays: widget.employee.workingDays,
      totalAmount: widget.employee.totalAmount,
      amountReceived: widget.employee.amountReceived,
      imagePath: widget.employee.imagePath,
      phoneNumber: widget.employee.phoneNumber,
    );
  }

  void _updateWorkingDays(int change) {
    setState(() {
      _employee.workingDays += change;
      _employee.totalAmount = _employee.workingDays * fixedSalary;
    });
  }

  void _saveChanges() {
    widget.updateEmployee(_employee);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 40.0,
            backgroundImage: _employee.imagePath != null
                ? FileImage(File(_employee.imagePath!))
                : const AssetImage('assets/images/placeholder.png')
                    as ImageProvider,
          ),
          const SizedBox(height: 16.0),
          Text(_employee.name, style: const TextStyle(fontSize: 18.0)),
          const SizedBox(height: 8.0),
          Text(_employee.phoneNumber ?? ''),
          const SizedBox(height: 16.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('Working Days:'),
                  Text(_employee.workingDays.toString()),
                ],
              ),
              Row(
                children: [
                  const Text('Total Salary:'),
                  Text(_employee.totalAmount.toStringAsFixed(2)),
                ],
              ),
              Row(
                children: [
                  const Text('Amount Received:'),
                  Text(_employee.amountReceived.toStringAsFixed(2)),
                ],
              ),
              Row(
                children: [
                  const Text('Amount Remaining:'),
                  Text((_employee.totalAmount - _employee.amountReceived)
                      .toStringAsFixed(2)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => _updateWorkingDays(-1),
                icon: const Icon(Icons.remove),
              ),
              IconButton(
                onPressed: () => _updateWorkingDays(1),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _saveChanges,
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }
}
