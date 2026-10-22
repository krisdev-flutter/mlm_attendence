import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/models/app_user.dart';
import '../../dashboard/data/dummy_attendance_data.dart';
import '../../dashboard/models/employee.dart';
import '../models/attendance_record.dart';

class AttendanceController extends GetxController {
  final employees = DummyAttendanceData.employees.toList().obs;
  final records = <AttendanceRecord>[].obs;
  final search = ''.obs;
  final selectedDate = Rxn<DateTime>();
  final selectedRole = Rxn<EmployeeRole>();
  final activeTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _createTodayRecords();
    _createHistory();
  }

  void _createTodayRecords() {
    for (final employee in employees) {
      records.add(
        AttendanceRecord(
          id: 'ATT-${employee.id}-${_dateKey(DateTime.now())}',
          userId: employee.id,
          employeeName: employee.name,
          email: employee.email,
          role: employee.role,
          date: DateTime.now(),
          checkInTime: employee.checkIn,
          checkOutTime: employee.checkOut,
        ),
      );
    }
  }

  void _createHistory() {
    final now = DateTime.now();
    for (final employee in employees) {
      for (var day = 1; day <= 6; day++) {
        final date = DateTime(
          now.year,
          now.month,
          now.day,
        ).subtract(Duration(days: day));
        final checkedIn = (employee.id.hashCode + day) % 5 != 0;
        final start = checkedIn
            ? DateTime(
                date.year,
                date.month,
                date.day,
                8 + day % 2,
                10 + day % 4,
              )
            : null;
        final end = checkedIn && day % 4 != 0
            ? DateTime(date.year, date.month, date.day, 16 + day % 2, 35)
            : null;
        records.add(
          AttendanceRecord(
            id: 'ATT-${employee.id}-${_dateKey(date)}',
            userId: employee.id,
            employeeName: employee.name,
            email: employee.email,
            role: employee.role,
            date: date,
            checkInTime: start,
            checkOutTime: end,
          ),
        );
      }
    }
  }

  static String _dateKey(DateTime date) =>
      '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';

  AppUser get currentUser => Get.find<AuthController>().currentUser.value;
  Employee get signedInEmployee {
    final email = currentUser.email;
    final found = employees.firstWhereOrNull((e) => e.email == email);
    if (found != null) return found;
    return employees.first;
  }

  bool get isAdmin => currentUser.role == UserRole.admin;
  bool get isSenior => currentUser.role == UserRole.seniorStaff;
  bool get isStaff => currentUser.role == UserRole.staff;

  List<Employee> get staffOnly =>
      employees.where((e) => e.role == EmployeeRole.staff).toList();
  List<AttendanceRecord> get todayRecords =>
      records.where((r) => r.isToday).toList();
  List<AttendanceRecord> get visibleRecords {
    final query = search.value.trim().toLowerCase();
    final date = selectedDate.value;
    return records.where((record) {
      if (isSenior && record.role != EmployeeRole.staff) return false;
      if (isStaff && record.userId != signedInEmployee.id) return false;
      if (selectedRole.value != null && record.role != selectedRole.value)
        return false;
      if (date != null &&
          !(record.date.year == date.year &&
              record.date.month == date.month &&
              record.date.day == date.day))
        return false;
      if (query.isNotEmpty &&
          !record.employeeName.toLowerCase().contains(query) &&
          !record.email.toLowerCase().contains(query) &&
          !record.userId.toLowerCase().contains(query))
        return false;
      return true;
    }).toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  List<AttendanceRecord> get ownHistory =>
      records.where((r) => r.userId == signedInEmployee.id).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
  AttendanceRecord get myTodayRecord =>
      records.firstWhere((r) => r.userId == signedInEmployee.id && r.isToday);
  int get totalUsers => employees.length;
  int get staffCount => staffOnly.length;
  int get seniorCount =>
      employees.where((e) => e.role == EmployeeRole.seniorStaff).length;
  int get checkedInCount =>
      todayRecords.where((r) => r.checkInTime != null).length;
  int get notCheckedInCount => totalUsers - checkedInCount;
  int get staffCheckedInCount => todayRecords
      .where((r) => r.role == EmployeeRole.staff && r.checkInTime != null)
      .length;
  int get staffNotCheckedInCount => staffCount - staffCheckedInCount;

  void updateSearch(String value) => search.value = value;
  void updateDate(DateTime? value) => selectedDate.value = value;
  void updateRole(EmployeeRole? value) => selectedRole.value = value;
  void clearFilters() {
    search.value = '';
    selectedDate.value = null;
    selectedRole.value = null;
  }

  void checkIn() {
    final record = myTodayRecord;
    if (record.checkInTime != null) return;
    record.checkInTime = DateTime.now();
    records.refresh();
    _syncEmployee(record);
    Get.snackbar(
      'Check-in recorded',
      'Your check-in time has been saved.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void checkOut() {
    final record = myTodayRecord;
    if (record.checkInTime == null || record.checkOutTime != null) return;
    record.checkOutTime = DateTime.now();
    records.refresh();
    _syncEmployee(record);
    Get.snackbar(
      'Check-out recorded',
      'Your attendance for today is complete.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void _syncEmployee(AttendanceRecord record) {
    final index = employees.indexWhere((e) => e.id == record.userId);
    if (index < 0) return;
    final old = employees[index];
    employees[index] = Employee(
      id: old.id,
      name: old.name,
      email: old.email,
      role: old.role,
      employeeId: old.employeeId,
      checkIn: record.checkInTime,
      checkOut: record.checkOutTime,
    );
  }
}
