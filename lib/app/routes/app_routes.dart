import 'package:get/get.dart';
import 'package:mlm_attendence/features/auth/views/login_screen.dart';
import 'package:mlm_attendence/features/dashboard/bindings/admin_dashboard_binding.dart';
import 'package:mlm_attendence/features/dashboard/views/admin_dashboard_screen.dart';
import 'package:mlm_attendence/features/dashboard/views/senior_staff_dashboard.dart';
import 'package:mlm_attendence/features/dashboard/views/splash_screen.dart';
import 'package:mlm_attendence/features/dashboard/views/staff_dashboard.dart';

class AppPages {
  AppPages._();

  static const String splash = '/splash';
  static const String login = '/login';
  static const String adminDashboard = '/admin-dashboard';
  static const String seniorStaffDashboard = '/senior-staff-dashboard';
  static const String staffDashboard = '/staff-dashboard';

  static final List<GetPage<dynamic>> getPages = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(
      name: adminDashboard,
      page: () => const AdminDashboardScreen(),
      binding: AdminDashboardBinding(),
    ),
    GetPage(
      name: seniorStaffDashboard,
      page: () => const SeniorStaffDashboard(),
    ),
    GetPage(name: staffDashboard, page: () => const StaffDashboard()),
  ];
}
