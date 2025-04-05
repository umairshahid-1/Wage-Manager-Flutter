import 'package:hive/hive.dart';

part 'employee_model.g.dart';

@HiveType(typeId: 0)
class Employee extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int workingDays;

  @HiveField(3)
  int totalAmount;

  @HiveField(4)
  int amountReceived;

  @HiveField(5)
  String? imagePath;

  @HiveField(6)
  String? phoneNumber;

  @HiveField(7)
  List<WorkingDay> workingDaysList;

  Employee({
    required this.id,
    required this.name,
    required this.workingDays,
    required this.totalAmount,
    this.amountReceived = 0,
    this.imagePath,
    this.phoneNumber,
    List<WorkingDay>? workingDaysList,
  }) : workingDaysList = workingDaysList ?? [];
}

@HiveType(typeId: 1)
class WorkingDay {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  bool isPaid;

  WorkingDay({required this.date, this.isPaid = false});
}