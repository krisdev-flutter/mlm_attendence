import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mlm_attendence/app/constants/app_constants.dart';
import 'package:mlm_attendence/features/auth/controllers/auth_controller.dart';
import 'package:mlm_attendence/features/auth/models/app_user.dart';
import 'package:mlm_attendence/features/auth/widgets/auth_text_field.dart';
import 'package:mlm_attendence/features/auth/widgets/login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isRestoring = false;

  AuthController get _auth => Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _restoreSessionAsync();
  }

  Future<void> _restoreSessionAsync() async {
    if (_isRestoring) return;
    _isRestoring = true;

    try {
      await _auth.restoreSession();
    } catch (e) {
      _auth.currentUser.value = AppUser();
    } finally {
      _isRestoring = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final double keyboardBottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(
              left: 24.0,
              right: 24.0,
              bottom: keyboardBottom,
              top: 24.0,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth = constraints.maxWidth > 600
                    ? 440.0
                    : double.infinity;
                final horizontalPadding = constraints.maxWidth > 600
                    ? 24.0
                    : 24.0;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(AppConstants.borderRadius),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 16,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  border: Border(
                                    right: BorderSide(
                                      color: colorScheme.onSurface,
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 24,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  shape: BoxShape.rectangle,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Welcome back',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A202C),
                            ),
                          ),
                          const Text(
                            'Sign in to access your workspace.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF64748B),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxWidth),
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadius,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                              vertical: AppConstants.fieldSpacing,
                            ),
                            child: Obx(() {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  AuthTextField(
                                    label: 'Email',
                                    icon: Icons.email,
                                    controller: _auth.emailController,
                                    fieldType: AuthFieldType.email,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email address.';
                                      }
                                      final emailRegex = RegExp(
                                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
                                      );
                                      if (!emailRegex.hasMatch(value)) {
                                        return 'Please enter a valid email address.';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: AppConstants.fieldSpacing,
                                  ),

                                  AuthTextField(
                                    label: 'Password',
                                    icon: Icons.lock,
                                    controller: _auth.passwordController,
                                    fieldType: AuthFieldType.password,
                                    ontap: () {
                                      _auth.obscurePassword.value =
                                          !_auth.obscurePassword.value;
                                    },
                                    obscureText: _auth.obscurePassword.value,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password.';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: AppConstants.fieldSpacing,
                                  ),

                                  Obx(
                                    () => LoginButton(
                                      onPressed: _auth.isLoading.value
                                          ? null
                                          : () => _auth.login(),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: AppConstants.fieldSpacing,
                                  ),

                                  if (_auth.errorMessage.value != null &&
                                      _auth.errorMessage.value!.isNotEmpty)
                                    Container(
                                      padding: const EdgeInsets.all(12.0),
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.errorContainer,
                                        borderRadius: BorderRadius.circular(
                                          AppConstants.borderRadius,
                                        ),
                                      ),
                                      child: Text(
                                        _auth.errorMessage.value!,
                                        style: const TextStyle(
                                          color: Color(0xFFEF4444),
                                          fontSize: 12,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),

                                  Obx(
                                    () => _auth.isLoading.value
                                        ? const SizedBox.shrink()
                                        : _DemoAccountsSection(),
                                  ),

                                  const SizedBox(height: 24),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _DemoAccountsSection extends StatelessWidget {
  _DemoAccountsSection() : super(key: ValueKey('demo_accounts'));

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Demo Accounts',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 8),
          ...AppConstants.demoEmails.map(
            (email) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 16,
                    color: Color(0xFF64748B),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      email,
                      style: const TextStyle(
                        color: Color(0xFF1A202C),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '• admin@test.com → Admin',
            style: TextStyle(
              color: Color(0xFF10B981),
              fontSize: 11,
              fontStyle: FontStyle.italic,
            ),
          ),
          const Text(
            '• senior@test.com → Senior Staff',
            style: TextStyle(
              color: Color(0xFF6366F1),
              fontSize: 11,
              fontStyle: FontStyle.italic,
            ),
          ),
          const Text(
            '• staff@test.com → Staff',
            style: TextStyle(
              color: Color(0xFF38BDF8),
              fontSize: 11,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
