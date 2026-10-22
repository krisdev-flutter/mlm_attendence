import 'package:flutter/material.dart';

enum EmployeeRole { admin, seniorStaff, staff, unknown }

extension EmployeeRoleExtension on EmployeeRole {
  String get displayName => switch (this) {
        EmployeeRole.admin => 'Admin',
        EmployeeRole.seniorStaff => 'Senior Staff',
        EmployeeRole.staff => 'Staff',
        EmployeeRole.unknown => 'User',
      };

  Color get accentColor => switch (this) {
        EmployeeRole.admin => const Color(0xFF1B2A4A),
        EmployeeRole.seniorStaff => const Color(0xFF6C5CE7),
        EmployeeRole.staff => const Color(0xFF38BDF8),
        EmployeeRole.unknown => Colors.grey,
      };
}

class Employee {
  const Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.checkIn,
    this.checkOut,
    this.employeeId = '',
  });

  final String id;
  final String name;
  final String email;
  final EmployeeRole role;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final String employeeId;

  bool get checkedInToday {
    final value = checkIn;
    if (value == null) return false;
    final now = DateTime.now();
    return value.year == now.year &&
        value.month == now.month &&
        value.day == now.day;
  }

  String get checkInDisplay => _formatTime(checkIn);
  String get checkOutDisplay => _formatTime(checkOut);

  String _formatTime(DateTime? value) {
    if (value == null) return '—';
    return '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
  }

  String get statusText {
    if (!checkedInToday) return 'Not Checked In';
    return checkOut != null ? 'Completed' : 'Working';
  }

  Color get statusColor {
    if (!checkedInToday) return Colors.grey;
    return checkOut != null ? Colors.green : Colors.orange;
  }

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'U';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
