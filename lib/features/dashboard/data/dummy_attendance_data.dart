import '../models/employee.dart';

DateTime _todayAt(int hour, int minute) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day, hour, minute);
}

class DummyAttendanceData {
  DummyAttendanceData._();

  static final List<Employee> employees = [
    Employee(
      id: 'E000',
      name: 'Alex Morgan',
      email: 'admin@test.com',
      role: EmployeeRole.admin,
      checkIn: _todayAt(8, 5),
      checkOut: _todayAt(17, 10),
      employeeId: 'EMP-000',
    ),
    Employee(
      id: 'E001',
      name: 'Maria Chen',
      email: 'senior@test.com',
      role: EmployeeRole.seniorStaff,
      checkIn: _todayAt(8, 15),
      checkOut: _todayAt(17, 30),
      employeeId: 'EMP-001',
    ),
    Employee(
      id: 'E002',
      name: 'John Smith',
      email: 'staff@test.com',
      role: EmployeeRole.staff,
      employeeId: 'EMP-002',
    ),
    Employee(
      id: 'E003',
      name: 'Alex Johnson',
      email: 'alex.johnson@company.com',
      role: EmployeeRole.staff,
      checkIn: _todayAt(9, 10),
      checkOut: _todayAt(18, 0),
      employeeId: 'EMP-003',
    ),
    Employee(
      id: 'E004',
      name: 'Priya Patel',
      email: 'priya.patel@company.com',
      role: EmployeeRole.seniorStaff,
      checkIn: _todayAt(8, 0),
      checkOut: _todayAt(16, 30),
      employeeId: 'EMP-004',
    ),
    Employee(
      id: 'E005',
      name: 'Carlos Rodriguez',
      email: 'carlos.rodriguez@company.com',
      role: EmployeeRole.staff,
      checkIn: _todayAt(7, 30),
      checkOut: _todayAt(15, 45),
      employeeId: 'EMP-005',
    ),
    Employee(
      id: 'E006',
      name: 'Sophie Martin',
      email: 'sophie.martin@company.com',
      role: EmployeeRole.staff,
      checkIn: _todayAt(8, 30),
      employeeId: 'EMP-006',
    ),
    Employee(
      id: 'E007',
      name: 'David Kim',
      email: 'david.kim@company.com',
      role: EmployeeRole.staff,
      employeeId: 'EMP-007',
    ),
    Employee(
      id: 'E008',
      name: 'Emma Wilson',
      email: 'emma.wilson@company.com',
      role: EmployeeRole.seniorStaff,
      checkIn: _todayAt(8, 45),
      checkOut: _todayAt(17, 15),
      employeeId: 'EMP-008',
    ),
    Employee(
      id: 'E009',
      name: 'Ryan Thompson',
      email: 'ryan.thompson@company.com',
      role: EmployeeRole.staff,
      checkIn: _todayAt(9, 0),
      checkOut: _todayAt(17, 30),
      employeeId: 'EMP-009',
    ),
    Employee(
      id: 'E010',
      name: 'Olivia Davis',
      email: 'olivia.davis@company.com',
      role: EmployeeRole.staff,
      checkIn: _todayAt(7, 50),
      checkOut: _todayAt(16, 20),
      employeeId: 'EMP-010',
    ),
    Employee(
      id: 'E011',
      name: 'Nathan Adams',
      email: 'nathan.adams@company.com',
      role: EmployeeRole.staff,
      checkIn: _todayAt(8, 20),
      checkOut: _todayAt(16, 55),
      employeeId: 'EMP-011',
    ),
    Employee(
      id: 'E012',
      name: 'Chloe Baker',
      email: 'chloe.baker@company.com',
      role: EmployeeRole.seniorStaff,
      checkIn: _todayAt(8, 15),
      employeeId: 'EMP-012',
    ),
    Employee(
      id: 'E013',
      name: 'Marcus Lee',
      email: 'marcus.lee@company.com',
      role: EmployeeRole.staff,
      checkIn: _todayAt(9, 30),
      checkOut: _todayAt(17, 45),
      employeeId: 'EMP-013',
    ),
    Employee(
      id: 'E014',
      name: 'Grace Taylor',
      email: 'grace.taylor@company.com',
      role: EmployeeRole.staff,
      employeeId: 'EMP-014',
    ),
  ];
}
