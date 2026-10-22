import 'package:get/get.dart';
import 'package:mlm_attendence/features/auth/controllers/auth_controller.dart';

class StaffBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
