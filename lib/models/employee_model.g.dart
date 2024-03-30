// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmployeeAdapter extends TypeAdapter<Employee> {
  @override
  final int typeId = 0;

  @override
  Employee read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Employee(
      id: fields[0] as int,
      name: fields[1] as String,
      workingDays: fields[2] as int,
      totalAmount: fields[3] as int,
      amountReceived: fields[4] as int,
      imagePath: fields[5] as String?,
      phoneNumber: fields[6] as String?,
      workingDaysList: (fields[7] as List).cast<WorkingDay>(),
    );
  }

  @override
  void write(BinaryWriter writer, Employee obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.workingDays)
      ..writeByte(3)
      ..write(obj.totalAmount)
      ..writeByte(4)
      ..write(obj.amountReceived)
      ..writeByte(5)
      ..write(obj.imagePath)
      ..writeByte(6)
      ..write(obj.phoneNumber)
      ..writeByte(7)
      ..write(obj.workingDaysList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmployeeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorkingDayAdapter extends TypeAdapter<WorkingDay> {
  @override
  final int typeId = 1;

  @override
  WorkingDay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkingDay(
      date: fields[0] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, WorkingDay obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkingDayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
