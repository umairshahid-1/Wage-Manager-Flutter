class Employee {
  int id;
  String name;
  int workingDays;
  int totalAmount;
  int amountReceived;
  String? imagePath;
  String? phoneNumber;

  Employee({
    required this.id,
    required this.name,
    required this.workingDays,
    required this.totalAmount,
    required this.amountReceived,
    this.imagePath,
    this.phoneNumber,
  });
}
