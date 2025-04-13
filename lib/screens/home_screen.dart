import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/utils/constants.dart';
import '/utils/theme.dart';
import '/screens/add_employee_screen.dart';
import '/services/hive_service.dart';
import '/widgets/employee_list_tile.dart';
import '/models/employee_model.dart';
import 'employee_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Employee> _employeesBox;
  bool _isSelectionMode = false;
  final List<Employee> _selectedEmployees = [];

  @override
  void initState() {
    super.initState();
    _employeesBox = HiveService.getEmployeesBox();
  }

  void addEmployee(Employee employee) async {
    await _employeesBox.add(employee);
    setState(() {});
  }

  void updateEmployee(Employee updatedEmployee) async {
    await updatedEmployee.save();
    setState(() {});
  }

  void deleteEmployee(Employee employee) async {
    await employee.delete();
    setState(() {});
  }

  void toggleSelection(Employee employee) {
    setState(() {
      if (_selectedEmployees.contains(employee)) {
        _selectedEmployees.remove(employee);
      } else {
        _selectedEmployees.add(employee);
      }

      // Exit selection mode if no employees are selected
      if (_selectedEmployees.isEmpty) {
        _isSelectionMode = false;
      }
    });
  }

  void enterSelectionMode(Employee employee) {
    setState(() {
      _isSelectionMode = true;
      _selectedEmployees.add(employee);
    });
  }

  void deleteSelected() async {
    for (var employee in _selectedEmployees) {
      await employee.delete();
    }
    setState(() {
      _selectedEmployees.clear();
      _isSelectionMode = false;
    });
  }

  void _showChangeFixedIncomeDialog() {
    final TextEditingController controller = TextEditingController(
      text: AppConstants.fixedSalary.toString(),
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Change Fixed Income'),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'New Fixed Income',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCEL'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Parse the input and update fixed income
                  int? newValue = int.tryParse(controller.text);
                  if (newValue != null && newValue > 0) {
                    await AppConstants.updateFixedSalary(newValue);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Fixed income updated to \$$newValue'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid amount'),
                      ),
                    );
                  }
                },
                child: const Text('SAVE'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            _isSelectionMode
                ? Text('${_selectedEmployees.length} selected')
                : const Text('Wage Manager'),
        actions:
            _isSelectionMode
                ? [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed:
                        _selectedEmployees.isNotEmpty ? deleteSelected : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _isSelectionMode = false;
                        _selectedEmployees.clear();
                      });
                    },
                  ),
                ]
                : [
                  IconButton(
                    icon: const Icon(Icons.attach_money),
                    onPressed: _showChangeFixedIncomeDialog,
                  ),
                ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _employeesBox.listenable(),
              builder: (context, Box<Employee> box, _) {
                final employees = box.values.toList().cast<Employee>();
                return ListView.builder(
                  itemCount: employees.length,
                  itemBuilder: (context, index) {
                    final employee = employees[index];
                    return Dismissible(
                      key: Key(employee.id.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text('Delete Employee'),
                                content: Text(
                                  'Are you sure you want to delete ${employee.name}?',
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
                      onDismissed: (direction) {
                        deleteEmployee(employee);
                      },
                      child: GestureDetector(
                        onLongPress: () {
                          if (!_isSelectionMode) {
                            enterSelectionMode(employee);
                          } else {
                            toggleSelection(employee);
                          }
                        },
                        onTap: () {
                          if (_isSelectionMode) {
                            toggleSelection(employee);
                          } else {
                            // Regular tap opens employee details
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.8,
                                  child: EmployeeDetailsScreen(
                                    employee: employee,
                                    updateEmployee: updateEmployee,
                                  ),
                                );
                              },
                            );
                          }
                        },
                        child: Container(
                          color:
                              _selectedEmployees.contains(employee)
                                  ? Colors.grey.withValues(alpha: 0.3)
                                  : null,
                          child: EmployeeListTile(
                            employee: employee,
                            updateEmployee: updateEmployee,
                            isSelected: _selectedEmployees.contains(employee),
                            selectionMode: _isSelectionMode,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: AddEmployeeScreen(
                  addEmployee: (dynamic employee) => addEmployee(employee),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
