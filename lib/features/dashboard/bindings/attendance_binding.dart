import 'package:get/get.dart';
import 'package:mlm_attendence/features/attendance/controllers/attendance_controller.dart';

class AttendanceBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AttendanceController>()) {
      Get.put(AttendanceController(), permanent: true);
    }
  }
}
