import 'package:get/get.dart';

import '../data/dummy_attendance_data.dart';
import '../models/employee.dart';

class AdminDashboardController extends GetxController {
  final RxList<Employee> employees = DummyAttendanceData.employees.toList().obs;
  final RxString searchQuery = ''.obs;
  final Rxn<EmployeeRole> roleFilter = Rxn<EmployeeRole>();
  final RxnString statusFilter = RxnString();
  final RxBool navExpanded = false.obs;
  final RxInt selectedNavIndex = 0.obs;

  final List<String> statuses = const [
    'Checked In',
    'Working',
    'Not Checked In',
    'Completed',
  ];

  int get totalUsers => employees.length;
  int get staffMembers =>
      employees.where((e) => e.role == EmployeeRole.staff).length;
  int get seniorStaffMembers =>
      employees.where((e) => e.role == EmployeeRole.seniorStaff).length;
  int get checkedInToday => employees.where((e) => e.checkedInToday).length;
  int get notCheckedInToday => totalUsers - checkedInToday;

  List<EmployeeRole> get availableRoles {
    final roles = employees.map((e) => e.role).toSet().toList();
    if (!roles.contains(EmployeeRole.unknown)) roles.add(EmployeeRole.unknown);
    roles.sort((a, b) => a.displayName.compareTo(b.displayName));
    return roles;
  }

  List<Employee> get filteredEmployees {
    final query = searchQuery.value.trim().toLowerCase();
    final selectedRole = roleFilter.value;
    final selectedStatus = statusFilter.value;

    final result = employees.where((employee) {
      if (selectedRole != null && employee.role != selectedRole) return false;
      if (query.isNotEmpty &&
          !employee.name.toLowerCase().contains(query) &&
          !employee.email.toLowerCase().contains(query) &&
          !employee.employeeId.toLowerCase().contains(query)) {
        return false;
      }

      final checkedIn = employee.checkedInToday;
      switch (selectedStatus) {
        case 'Checked In':
          if (!checkedIn) return false;
          break;
        case 'Working':
          if (!checkedIn || employee.checkOut != null) return false;
          break;
        case 'Not Checked In':
          if (checkedIn) return false;
          break;
        case 'Completed':
          if (!checkedIn || employee.checkOut == null) return false;
          break;
      }
      return true;
    }).toList();

    result.sort((a, b) {
      if (a.checkIn == null && b.checkIn == null) return a.name.compareTo(b.name);
      if (a.checkIn == null) return 1;
      if (b.checkIn == null) return -1;
      return b.checkIn!.compareTo(a.checkIn!);
    });
    return result;
  }

  void updateSearch(String value) => searchQuery.value = value;
  void updateRole(EmployeeRole? value) => roleFilter.value = value;
  void updateStatus(String? value) => statusFilter.value = value;
  void selectNavigation(int index) => selectedNavIndex.value = index;
  void toggleNavigation() => navExpanded.toggle();

  void resetFilters() {
    searchQuery.value = '';
    roleFilter.value = null;
    statusFilter.value = null;
  }

  void refreshAttendance() {
    employees.refresh();
  }
}
