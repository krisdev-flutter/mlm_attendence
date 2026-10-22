import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mlm_attendence/features/auth/controllers/auth_controller.dart';

enum AuthFieldType { email, password }

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    required this.fieldType,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.autofocus = false,
    this.onChanged,
    this.ontap,
    this.validator,
    this.onFieldSubmitted,
  });

  final String label;
  final TextEditingController controller;
  final IconData icon;
  final AuthFieldType fieldType;
  final bool obscureText;
  final TextInputType keyboardType;
  final int maxLines;
  final bool autofocus;
  final GestureTapCallback? ontap;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final colorScheme = Theme.of(context).colorScheme;

    final String fieldValue0 = fieldType == AuthFieldType.email
        ? authController.emailController.value.text
        : authController.passwordController.value.text;

    final String fieldValue = fieldValue0;
    final hasError = validator != null && validator!(fieldValue ?? '') != null;

    final borderColor = hasError
        ? Theme.of(context).colorScheme.error
        : colorScheme.outline;

    final fillColor = Colors.white;

    return TextFormField(
      autofocus: autofocus,
      keyboardType: keyboardType,
      maxLines: maxLines,
      obscureText: fieldType == AuthFieldType.password ? obscureText : false,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: colorScheme.onSurface),
        hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.5)),
        prefixIcon: Icon(icon, color: colorScheme.onSurface),
        suffixIcon: InkWell(
          onTap: ontap,
          child: SizedBox(
            width: 30,
            child: Center(
              child: fieldType == AuthFieldType.password && obscureText
                  ? const Text(
                      'Show',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
                    )
                  : null,
            ),
          ),
        ),
        filled: true,
        fillColor: fillColor,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 14.0,
        ),
      ),
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      controller: controller,
      style: TextStyle(color: colorScheme.onSurface),
      onChanged: (value) {
        if (fieldType == AuthFieldType.email) {
          authController.emailController.text = value;
        } else {
          authController.passwordController.text = value;
        }

        onChanged?.call(value);
      },
    );
  }
}
