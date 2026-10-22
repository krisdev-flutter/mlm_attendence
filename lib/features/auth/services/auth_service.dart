import 'package:mlm_attendence/features/auth/models/app_user.dart';

class AuthService {
  static final List<_DemoUser> _demoUsers = [
    _DemoUser(
      email: 'admin@test.com',
      password: 'Admin@123',
      role: UserRole.admin,
    ),
    _DemoUser(
      email: 'senior@test.com',
      password: 'Senior@123',
      role: UserRole.seniorStaff,
    ),
    _DemoUser(
      email: 'staff@test.com',
      password: 'Staff@123',
      role: UserRole.staff,
    ),
  ];

  AuthService();

  String getEmail(int index) => _demoUsers[index].email;
  String getPassword(int index) => _demoUsers[index].password;
  UserRole getRole(int index) => _demoUsers[index].role;
  int get userCount => _demoUsers.length;

  Object? validateAndAuthenticate(
    String email,
    String password,
    AppUser? currentUser,
  ) {
    final trimmedEmail = email.trim();

    if (trimmedEmail.isEmpty) {
      return 'Please enter your email address.';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}',
    );
    if (!emailRegex.hasMatch(trimmedEmail)) {
      return 'Please enter a valid email address.';
    }

    if (password.isEmpty) {
      return 'Please enter your password.';
    }

    for (final user in _demoUsers) {
      if (user.email == trimmedEmail && user.password == password) {
        return AppUser(email: user.email, role: user.role);
      }
    }

    return 'Invalid email or password. Please try again.';
  }

  static bool isKnownEmail(String email) {
    final trimmed = email.trim();
    return _demoUsers.any((user) => user.email == trimmed);
  }

  static UserRole? getRoleForEmail(String email) {
    final trimmed = email.trim();
    for (final user in _demoUsers) {
      if (user.email == trimmed) {
        return user.role;
      }
    }
    return null;
  }
}

class _DemoUser {
  _DemoUser({required this.email, required this.password, required this.role});

  final String email;
  final String password;
  final UserRole role;
}
