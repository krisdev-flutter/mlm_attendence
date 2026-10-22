import 'package:get/get.dart';
import 'package:mlm_attendence/features/auth/controllers/auth_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
