import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wage_manager/widgets/reusable_text_field.dart';
import '/models/employee_model.dart';
import '/utils/constants.dart';
import '/utils/theme.dart';

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

  @override
  void initState() {
    super.initState();
    _employee = widget.employee;
    _nameController.text = _employee.name;
    _phoneController.text = _employee.phoneNumber ?? '';
    _calculatePaymentSummary();
  }

  // Calculate paid and remaining amounts based on workingDaysList
  void _calculatePaymentSummary() {
    int paidDays = _employee.workingDaysList.where((day) => day.isPaid).length;
    int paidAmount = paidDays * AppConstants.fixedSalary;

    setState(() {
      _employee.workingDays = _employee.workingDaysList.length;
      _employee.totalAmount = _employee.workingDays * AppConstants.fixedSalary;
      _employee.amountReceived = paidAmount;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _employee.imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _addWorkingDay() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      // Check if the date already exists
      bool dateExists = _employee.workingDaysList.any(
        (day) =>
            day.date.year == pickedDate.year &&
            day.date.month == pickedDate.month &&
            day.date.day == pickedDate.day,
      );

      if (!dateExists) {
        setState(() {
          _employee.workingDaysList.add(WorkingDay(date: pickedDate));
          _calculatePaymentSummary();
        });
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('This date already exists')),
        );
      }
    }
  }

  void _togglePaidStatus(int index) {
    setState(() {
      _employee.workingDaysList[index].isPaid =
          !_employee.workingDaysList[index].isPaid;
      _calculatePaymentSummary();
    });
  }

  void _removeWorkingDay(int index) {
    setState(() {
      _employee.workingDaysList.removeAt(index);
      _calculatePaymentSummary();
    });
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      _employee.name = _nameController.text;
      _employee.phoneNumber = _phoneController.text;
      widget.updateEmployee(_employee);
      Navigator.pop(context);
    }
  }

  // Sort working days by date (newest first)
  List<WorkingDay> get _sortedWorkingDays {
    final days = List<WorkingDay>.from(_employee.workingDaysList);
    days.sort((a, b) => b.date.compareTo(a.date));
    return days;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDay(DateTime date) {
    List<String> weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return weekdays[date.weekday - 1];
  }

  bool _isValidName(String value) {
    //regular expression pattern to allow only letters, spaces
    RegExp nameRegExp = RegExp(r'^[a-zA-Z\s]+$');
    return nameRegExp.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employee Details')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile picture in the middle
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60.0,
                          backgroundImage:
                              _employee.imagePath != null
                                  ? FileImage(File(_employee.imagePath!))
                                  : null,
                          backgroundColor: Colors.grey.shade200,
                          child:
                              _employee.imagePath == null
                                  ? const Icon(
                                    Icons.person,
                                    size: 60.0,
                                    color: primaryColorDark,
                                  )
                                  : null,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),

                ReusableTextField(
                  labelText: 'Name',
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    } else if (!_isValidName(value)) {
                      return 'Please enter a valid name without special characters';
                    }
                    return null;
                  },
                  prefixIcon: Icons.person_outline,
                ),

                const SizedBox(height: 16.0),

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
                  prefixIcon: Icons.phone_outlined,
                ), // For phone number

                const SizedBox(height: 24.0),

                // Working days and salary info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoItem(
                            'Working Days',
                            _employee.workingDays.toString(),
                            Icons.calendar_today,
                          ),
                          _buildInfoItem(
                            'Total Salary',
                            _employee.totalAmount.toString(),
                            Icons.account_balance_wallet,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoItem(
                            'Paid Amount',
                            _employee.amountReceived.toString(),
                            Icons.payments,
                            color: Colors.green,
                          ),
                          _buildInfoItem(
                            'Remaining',
                            (_employee.totalAmount - _employee.amountReceived)
                                .toString(),
                            Icons.money_off,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),

                // Add working day button
                ElevatedButton.icon(
                  onPressed: _addWorkingDay,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Working Day'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),

                // Working days list with checkboxes
                const Text(
                  'Working Days',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _sortedWorkingDays.length,
                  itemBuilder: (context, index) {
                    final workingDay = _sortedWorkingDays[index];
                    return Dismissible(
                      key: Key(workingDay.date.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        int originalIndex = _employee.workingDaysList.indexOf(
                          workingDay,
                        );
                        _removeWorkingDay(originalIndex);
                      },
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text('Delete Working Day'),
                                content: const Text(
                                  'Are you sure you want to delete this working day?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(false),
                                    child: const Text('CANCEL'),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(true),
                                    child: const Text('DELETE'),
                                  ),
                                ],
                              ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: primaryColorLight.withValues(
                              alpha: 0.2,
                            ),
                            child: Text(
                              workingDay.date.day.toString(),
                              style: const TextStyle(
                                color: primaryColorDark,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            _formatDay(workingDay.date),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(_formatDate(workingDay.date)),
                          trailing: Checkbox(
                            value: workingDay.isPaid,
                            activeColor: primaryColor,
                            onChanged: (value) {
                              int originalIndex = _employee.workingDaysList
                                  .indexOf(workingDay);
                              _togglePaidStatus(originalIndex);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24.0),

                // Save button
                ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColorDark,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('SAVE CHANGES'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    String label,
    String value,
    IconData icon, {
    Color color = Colors.black87,
  }) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
