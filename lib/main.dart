import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mlm_attendence/app/routes/app_routes.dart';
import 'package:mlm_attendence/features/auth/controllers/auth_controller.dart';
import 'package:mlm_attendence/features/auth/models/app_user.dart';
import 'package:mlm_attendence/features/auth/services/auth_service.dart';
import 'package:mlm_attendence/features/auth/views/login_screen.dart';
import 'package:mlm_attendence/features/dashboard/bindings/admin_dashboard_binding.dart';
import 'package:mlm_attendence/features/dashboard/views/admin_dashboard_screen.dart';
import 'package:mlm_attendence/features/dashboard/views/senior_staff_dashboard.dart';
import 'package:mlm_attendence/features/dashboard/views/splash_screen.dart';
import 'package:mlm_attendence/features/dashboard/views/staff_dashboard.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MLMAttendenceApp());
}

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
  }
}

class MLMAttendenceApp extends StatelessWidget {
  const MLMAttendenceApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return FutureBuilder(
      future: auth.initialSessionRestore(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final initialRoute = _determineInitialRoute(auth);

        return GetMaterialApp(
          title: 'MLM Attendance',
          debugShowCheckedModeBanner: false,
          initialBinding: InitialBinding(),
          initialRoute: initialRoute,
          getPages: [
            GetPage(name: AppPages.splash, page: () => const SplashScreen()),
            GetPage(name: AppPages.login, page: () => const LoginScreen()),
            GetPage(
              name: AppPages.adminDashboard,
              page: () => const AdminDashboardScreen(),
              binding: AdminDashboardBinding(),
            ),
            GetPage(
              name: AppPages.seniorStaffDashboard,
              page: () => const SeniorStaffDashboard(),
            ),
            GetPage(name: AppPages.staffDashboard, page: () => const StaffDashboard()),
          ],
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3156D8)),
          ),
          darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
          themeMode: ThemeMode.light,
        );
      },
    );
  }

  static String _determineInitialRoute(AuthController auth) {
    final user = auth.currentUser.value;
    if (user.email != null && user.role != null) {
      if (AuthService.isKnownEmail(user.email!)) {
        switch (user.role) {
          case UserRole.admin:
            return AppPages.adminDashboard;
          case UserRole.seniorStaff:
            return AppPages.seniorStaffDashboard;
          case UserRole.staff:
            return AppPages.staffDashboard;
          default:
            return AppPages.login;
        }
      }
    }
    return AppPages.splash;
  }
}