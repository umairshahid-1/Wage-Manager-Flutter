import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '/utils/constants.dart';
import '/utils/theme.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _workingDaysController = TextEditingController();
  final _totalSalaryController = TextEditingController();
  final _amountReceivedController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _employee = widget.employee;
    _nameController.text = _employee.name;
    _phoneController.text = _employee.phoneNumber ?? '';
    _workingDaysController.text = _employee.workingDays.toString();
    _totalSalaryController.text = _employee.totalAmount.toStringAsFixed(0);
    _amountReceivedController.text =
        _employee.amountReceived.toStringAsFixed(0);
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _employee.imagePath = pickedFile.path;
      });
    }
  }

  void _updateWorkingDays(int change) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final newWorkingDays = _employee.workingDays + change;
      if (newWorkingDays >= 0) {
        setState(() {
          _employee.workingDays = newWorkingDays;
          _employee.totalAmount = _employee.workingDays * fixedSalary;
          _employee.workingDaysList.add(WorkingDay(date: pickedDate));
          _workingDaysController.text = _employee.workingDays.toString();
          _totalSalaryController.text =
              _employee.totalAmount.toStringAsFixed(0);
          _updateAmountRemaining();
        });
      }
    }
  }

  void _updateAmountRemaining() {
    final amountRemaining = _employee.totalAmount - _employee.amountReceived;
    if (amountRemaining >= 0) {
      _employee.amountReceived = _employee.totalAmount;
      _amountReceivedController.text =
          _employee.amountReceived.toStringAsFixed(0);
    }
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      _employee
        ..name = _nameController.text
        ..phoneNumber = _phoneController.text
        ..workingDays = int.parse(_workingDaysController.text)
        ..totalAmount = int.parse(_totalSalaryController.text)
        ..amountReceived = int.parse(_amountReceivedController.text);
      widget.updateEmployee(_employee);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Employee'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50.0,
                        backgroundImage: _employee.imagePath != null
                            ? FileImage(File(_employee.imagePath!))
                            : null,
                        backgroundColor: Colors.grey.shade200,
                        child: _employee.imagePath == null
                            ? const Icon(
                                Icons.person_2,
                                size: 50.0,
                                color: primaryColorDark,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a name';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _phoneController,
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Working Days'),
                        SizedBox(
                          width: 100.0,
                          child: TextFormField(
                            controller: _workingDaysController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || int.parse(value) < 0) {
                                return 'Working days must be greater than or equal to 0';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total Salary'),
                        SizedBox(
                          width: 100.0,
                          child: TextFormField(
                            controller: _totalSalaryController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || int.parse(value) < 0) {
                                return 'Total salary must be greater than or equal to 0';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Amount Received'),
                        SizedBox(
                          width: 100.0,
                          child: TextFormField(
                            controller: _amountReceivedController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || int.parse(value) < 0) {
                                return 'Amount received must be greater than or equal to 0';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _updateAmountRemaining();
                            },
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Amount Remaining'),
                        Text(
                          (_employee.totalAmount - _employee.amountReceived)
                              .toStringAsFixed(0),
                        ),
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
                const Text(
                  'Working Days List',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _employee.workingDaysList.length,
                  itemBuilder: (context, index) {
                    final workingDay = _employee.workingDaysList[index];
                    return ListTile(
                      title: Text(
                        '${workingDay.date.day}/${workingDay.date.month}/${workingDay.date.year}',
                      ),
                      trailing: const Icon(Icons.work),
                    );
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _saveChanges,
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
