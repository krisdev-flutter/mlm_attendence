import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mlm_attendence/features/auth/controllers/auth_controller.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.onPressed,
    this.text = 'Sign In',
  });

  final VoidCallback? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final colorScheme = Theme.of(context).colorScheme;

    return Obx(
      () => ElevatedButton(
        onPressed: authController.isLoading.value ? null : onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 2,
          backgroundColor: authController.isLoading.value
              ? colorScheme.onSurface.withOpacity(0.1)
              : colorScheme.primary,
          foregroundColor: authController.isLoading.value
              ? colorScheme.onSurface
              : Colors.white,
        ),
        child: authController.isLoading.value
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Sign In',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
