import 'package:flutter/material.dart';

import '../../features/dashboard/models/employee.dart';

class RoleChip extends StatelessWidget {
  const RoleChip({super.key, required this.role});
  final EmployeeRole role;

  @override
  Widget build(BuildContext context) {
    final color = role.accentColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(.1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        role.displayName,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w500),
      ),
    );
  }
}
