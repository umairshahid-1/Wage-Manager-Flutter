import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wage_manager/utils/theme.dart';
import '/screens/add_employee_screen.dart';
import '/services/hive_service.dart';
import '/widgets/employee_list_tile.dart';
import '/models/employee_model.dart';
// import '/models/employee_model.dart' as original_employee;

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
        title: const Text('Wage Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
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
                    return EmployeeListTile(
                      employee: employees[index],
                      updateEmployee: updateEmployee,
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
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled:
                true, // Set to true to cover the middle of the screen
            builder: (context) {
              return SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.7, // Adjust the height as needed
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
