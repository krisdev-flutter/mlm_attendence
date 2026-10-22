import 'package:flutter/material.dart';
import '../../../features/dashboard/models/employee.dart';

class AttendanceRecord {
  AttendanceRecord({
    required this.id,
    required this.userId,
    required this.employeeName,
    required this.email,
    required this.role,
    required this.date,
    this.checkInTime,
    this.checkOutTime,
  });

  final String id;
  final String userId;
  final String employeeName;
  final String email;
  final EmployeeRole role;
  final DateTime date;
  DateTime? checkInTime;
  DateTime? checkOutTime;

  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  String get status {
    if (checkInTime == null) return 'Not checked in';
    if (checkOutTime == null) return 'Checked in';
    return 'Checked out';
  }

  Color get statusColor {
    if (checkInTime == null) return const Color(0xFFDA8A18);
    if (checkOutTime == null) return const Color(0xFF2878D0);
    return const Color(0xFF16865B);
  }

  String timeText(DateTime? value) {
    if (value == null) return '—';
    final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
    final minute = value.minute.toString().padLeft(2, '0');
    return '$hour:$minute ${value.hour >= 12 ? 'PM' : 'AM'}';
  }

  String get dateText => '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}
