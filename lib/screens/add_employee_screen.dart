import 'dart:io';
import 'package:flutter/material.dart';
import '/services/image_picker_service.dart';
import '/utils/constants.dart';
import '/widgets/reusable_text_field.dart';
import '/models/employee_model.dart';

class AddEmployeeScreen extends StatefulWidget {
  final Function(Employee) addEmployee;

  const AddEmployeeScreen({super.key, required this.addEmployee});

  @override
  // ignore: library_private_types_in_public_api
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _imagePath;

  void _pickImage() async {
    final imagePath = await getImageFromGallery();
    setState(() {
      _imagePath = imagePath;
    });
  }

  void _addEmployee() {
    if (_formKey.currentState!.validate()) {
      final employee = Employee(
        id: DateTime.now().millisecondsSinceEpoch,
        name: _nameController.text,
        workingDays: 1, // Set default working days
        totalAmount: fixedSalary, // Set fixed salary
        imagePath: _imagePath,
        phoneNumber: _phoneController.text,
        amountReceived: 250,
      );
      widget.addEmployee(employee);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 40.0,
                backgroundImage: _imagePath != null
                    ? FileImage(File(_imagePath!))
                    : const AssetImage('assets/images/placeholder.png')
                        as ImageProvider,
              ),
            ),
            const SizedBox(height: 16.0),
            ReusableTextField(
              controller: _nameController,
              labelText: 'Name',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            ReusableTextField(
              controller: _phoneController,
              labelText: 'Phone Number',
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addEmployee,
              child: const Text('Add Employee'),
            ),
          ],
        ),
      ),
    );
  }
}
