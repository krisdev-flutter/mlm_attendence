# Flutter Attendance Management App

## Project Overview

This is a Flutter-based Attendance Management Application developed using GetX. The application manages employee attendance with role-based access for Admin, Senior Staff, and Staff.

## Workflow

1. **Login:** Users log in using their credentials and are directed to the dashboard based on their role.
2. **Admin:** Can view attendance records for all employees, filter records, manage users, and track personal attendance.
3. **Senior Staff:** Can view personal attendance and monitor attendance records of Staff members.
4. **Staff:** Can check in, check out, and view their own attendance history.
5. **Check-In:** When a user checks in, the application records the current time against that user's attendance for the day.
6. **Check-Out:** After checking in, the user can check out. The application records the check-out time for the same attendance record.
7. **Attendance History:** Users can review previous attendance records. Team attendance visibility depends on the user's role.
8. **Session Management:** The application saves the login session locally so the user can continue without logging in again when a valid session is restored.
9. **Logout:** Users can log out, clear their saved session, and return to the login screen.

## Tech Stack

- Flutter
- Dart
- GetX
- Shared Preferences

## Demo Accounts

| Role | Email | Password |
|---|---|---|
| Admin | admin@test.com | Admin@123 |
| Senior Staff | senior@test.com | Senior@123 |
| Staff | staff@test.com | Staff@123 |

## Run the Project

flutter pub get
flutter run

