import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mlm_attendence/features/auth/models/app_user.dart';
import 'package:mlm_attendence/features/auth/services/auth_service.dart';

class AuthController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final RxBool obscurePassword = true.obs;
  final RxBool isLoading = false.obs;
  final Rx<AppUser> currentUser = AppUser().obs;
  final RxnString errorMessage = RxnString();

  static const String _userKey = 'auth_user_data';

  @override
  void onInit() {
    super.onInit();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      currentUser.value = AppUser.fromMap(userMap);
    }
  }

  Future<bool> initialSessionRestore() async {
    // Ensure session is loaded from persistent storage
    await _loadSession();

    final user = currentUser.value;
    if (user.email != null && user.role != null) {
      if (AuthService.isKnownEmail(user.email!)) {
        return true;
      }
    }
    return false;
  }

  Future<void> _saveSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userMap = currentUser.value.toMap();
    await prefs.setString(_userKey, jsonEncode(userMap));
  }

  void onEmailChanged(String? value) {
    emailController.text = value.toString();
    errorMessage.value = null;
  }

  void onPasswordChanged(String? value) {
    passwordController.text = value.toString();
    errorMessage.value = null;
  }

  void togglePasswordVisibility() {
    obscurePassword.toggle();
  }

  Future<void> login() async {
    if (isLoading.value) return;

    final emailValue = emailController.value.text.trim();
    final passwordValue = passwordController.value.text;

    errorMessage.value = null;

    if (emailValue.isEmpty) {
      errorMessage.value = 'Please enter your email address.';
      return;
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(emailValue)) {
      errorMessage.value = 'Please enter a valid email address.';
      return;
    }

    if (passwordValue.isEmpty) {
      errorMessage.value = 'Please enter your password.';
      return;
    }

    isLoading.value = true;

    try {
      final result = AuthService().validateAndAuthenticate(
        emailValue,
        passwordValue,
        currentUser.value,
      );

      if (result is AppUser) {
        currentUser.value = result;
        errorMessage.value = null;
        await _saveSession();
        _navigateToDashboard(result.role!);
      } else if (result is String) {
        errorMessage.value = result;
      } else {
        errorMessage.value = 'Invalid email or password.';
      }
    } catch (e) {
      errorMessage.value = 'Something went wrong. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  void _navigateToDashboard(UserRole role) {
    switch (role) {
      case UserRole.admin:
        Get.offNamed('/admin-dashboard');
        break;

      case UserRole.seniorStaff:
        Get.offNamed('/senior-staff-dashboard');
        break;

      case UserRole.staff:
        Get.offNamed('/staff-dashboard');
        break;

      case UserRole.unknown:
        errorMessage.value = 'Unable to identify your user role.';
        currentUser.value = AppUser();
        break;
    }
  }

  Future<void> logout() async {
    currentUser.value = AppUser();
    emailController.text = "";
    passwordController.text = "";
    errorMessage.value = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);

    Get.offAllNamed('/login');
  }

  Future<bool> restoreSession() async {
    try {
      final user = currentUser.value;

      if (user.email == null || user.role == null) {
        currentUser.value = AppUser();
        return false;
      }

      await _saveSession();
      return true;
    } catch (e) {
      currentUser.value = AppUser();
      return false;
    }
  }

  String? validateForm() {
    final emailValue = emailController.value.text.trim();
    final passwordValue = passwordController.value.text;

    if (emailValue.isEmpty) {
      return 'Please enter your email address.';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(emailValue)) {
      return 'Please enter a valid email address.';
    }

    if (passwordValue.isEmpty) {
      return 'Please enter your password.';
    }

    return null;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
