enum UserRole {
  admin,
  seniorStaff,
  staff,
  unknown;

  String get displayName {
    switch (this) {
      case UserRole.admin: return 'Admin';
      case UserRole.seniorStaff: return 'Senior Staff';
      case UserRole.staff: return 'Staff';
      case UserRole.unknown: return 'User';
    }
  }

  String get value {
    switch (this) {
      case UserRole.admin: return 'admin';
      case UserRole.seniorStaff: return 'seniorStaff';
      case UserRole.staff: return 'staff';
      case UserRole.unknown: return 'unknown';
    }
  }

  static UserRole? fromString(String? role) {
    if (role == null) return null;
    switch (role.trim().toLowerCase()) {
      case 'admin': return UserRole.admin;
      case 'seniorstaff':
      case 'senior': return UserRole.seniorStaff;
      case 'staff': return UserRole.staff;
      default: return UserRole.unknown;
    }
  }
}

class AppUser {
  final String? email;
  final UserRole? role;

  const AppUser({ this.email,  this.role});

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      email: map['email'] as String? ?? '',
      role: UserRole.fromString(map['role'] as String?) ?? UserRole.unknown,
    );
  }

  Map<String, dynamic> toMap() {
    return {'email': email, 'role': role?.value};
  }

  bool hasRole(UserRole requiredRole) => role == requiredRole;

  @override
  String toString() => 'AppUser(email: $email, role: ${role?.displayName})';
}
