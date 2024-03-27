import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/screens/add_employee_screen.dart';
import '/services/hive_service.dart';
import '/widgets/employee_list_tile.dart';
// import '/models/employee_model.dart' as original_employee;
import '/models/employee_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Employee> _employeesBox;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Manager'),
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
                    return EmployeeListTile(
                      employee: employees[index],
                      updateEmployee: updateEmployee,
                    );
                  },
                );
              },
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.add,
              size: 42,
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return AddEmployeeScreen(
                    addEmployee: (dynamic employee) => addEmployee(employee),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
