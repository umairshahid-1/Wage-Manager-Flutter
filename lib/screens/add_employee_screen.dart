import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/utils/constants.dart';
import '/utils/theme.dart';
import '/models/employee_model.dart';
import '/widgets/reusable_text_field.dart';

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
    final ImagePicker picker = ImagePicker();
    final source = await showDialog<ImageSource>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Select Image Source'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, ImageSource.camera),
                child: const Text(
                  'Camera',
                  style: TextStyle(color: primaryColorDark),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, ImageSource.gallery),
                child: const Text(
                  'Gallery',
                  style: TextStyle(color: primaryColorDark),
                ),
              ),
            ],
          ),
    );

    if (source != null) {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imagePath = pickedFile.path;
        });
      }
    }
  }

  void _addEmployee() {
    if (_formKey.currentState!.validate()) {
      // Create initial working day entry for today
      final initialWorkingDay = WorkingDay(date: DateTime.now(), isPaid: false);

      final employee = Employee(
        id: DateTime.now().millisecondsSinceEpoch,
        name: _nameController.text,
        workingDays: 1,
        totalAmount: fixedSalary,
        imagePath: _imagePath,
        phoneNumber: _phoneController.text,
        amountReceived: 0,
        workingDaysList: [initialWorkingDay], // Initialize with today's entry
      );
      widget.addEmployee(employee);
      Navigator.pop(context);
    }
  }

  bool _isValidName(String value) {
    //regular expression pattern to allow only letters, spaces
    RegExp nameRegExp = RegExp(r'^[a-zA-Z\s]+$');
    return nameRegExp.hasMatch(value);
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
                radius: 50.0,
                backgroundImage:
                    _imagePath != null ? FileImage(File(_imagePath!)) : null,
                backgroundColor: Colors.grey.shade200,
                child:
                    _imagePath == null
                        ? const Icon(
                          Icons.person_2,
                          size: 50.0,
                          color: primaryColorDark,
                        )
                        : null,
              ),
            ),
            const SizedBox(height: 26.0),
            ReusableTextField(
              // For name
              labelText: 'Name',
              controller: _nameController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                } else if (!_isValidName(value)) {
                  return 'Please enter a valid name without special characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 26.0),
            ReusableTextField(
              labelText: 'Phone Number',
              controller: _phoneController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: false,
              ),
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return null;
                } else if (value.length != 11) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ), // For phone number
            const SizedBox(height: 26.0),
            ElevatedButton(
              onPressed: _addEmployee,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade100,
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text(
                'Add',
                style: TextStyle(
                  fontSize: 16.0,
                  color: primaryColorDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
