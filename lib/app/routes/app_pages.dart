import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mlm_attendence/app/routes/app_routes.dart';
import 'package:mlm_attendence/features/auth/controllers/auth_controller.dart';

class AppPagesWidget extends StatelessWidget {
  const AppPagesWidget({super.key, required this.initialRoute});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MLM Attendance',
      initialRoute: initialRoute,
      getPages: AppPages.getPages,
      initialBinding: BindingsBuilder(() {
        Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
      }),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light,
    );
  }
}
