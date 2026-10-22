import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mlm_attendence/app/routes/app_routes.dart';
import 'package:mlm_attendence/features/auth/controllers/auth_controller.dart';
import 'package:mlm_attendence/features/auth/views/login_screen.dart';
import 'package:mlm_attendence/features/dashboard/bindings/attendance_binding.dart';
import 'package:mlm_attendence/features/dashboard/views/admin_dashboard_screen.dart';
import 'package:mlm_attendence/features/dashboard/views/senior_staff_dashboard.dart';
import 'package:mlm_attendence/features/dashboard/views/staff_dashboard.dart';
import 'package:mlm_attendence/features/dashboard/views/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MLMAttendenceApp());
}

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController());
  }
}

class MLMAttendenceApp extends StatelessWidget {
  const MLMAttendenceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MLM Attendance',
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      initialRoute: AppPages.splash,
      getPages: [
        GetPage(name: AppPages.splash, page: () => const SplashScreen()),
        GetPage(name: AppPages.login, page: () => const LoginScreen()),
        GetPage(
          name: AppPages.adminDashboard,
          page: () => const AdminDashboardScreen(),
          binding: AttendanceBinding(),
        ),
        GetPage(
          name: AppPages.seniorStaffDashboard,
          page: () => const SeniorStaffDashboard(),
          binding: AttendanceBinding(),
        ),
        GetPage(
          name: AppPages.staffDashboard,
          page: () => const StaffDashboard(),
          binding: AttendanceBinding(),
        ),
      ],
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3156D8)),
      ),
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      themeMode: ThemeMode.light,
    );
  }
}
