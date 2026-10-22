import 'package:get/get.dart';
import 'package:mlm_attendence/features/auth/controllers/auth_controller.dart';

class SeniorStaffBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
