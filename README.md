# Flutter Attendance Management App

## 1. Project Overview

The Attendance Management App is built using Flutter and GetX. It provides role-based access for Admin, Senior Staff, and Staff to manage daily attendance, check-in/check-out times, and attendance history.

## 2. Installation and Setup

### Prerequisites
- Flutter SDK
- Dart SDK
- Android Studio or Visual Studio Code
- Android emulator or physical Android device
- Git

### Clone the Repository


git clone https://github.com/krisdev-flutter/mlm_attendence.git
cd mlm_attendence

### Install Dependencies

```bash
flutter pub get
```

### Run the Application

```bash
flutter run
```

### Run Static Analysis

```bash
flutter analyze
```

### Run Tests

```bash
flutter test
```

### Build APK

```bash
flutter build apk --release
```

The release APK is normally generated at:

`build/app/outputs/flutter-apk/app-release.apk`

## 3. Architecture Overview

The application uses Flutter for the UI and GetX for state management, dependency injection, and navigation.

- **Views:** Display login, dashboards, attendance history, and user management screens.
- **Controllers:** Handle user actions, attendance state, and application logic.
- **Models:** Represent employee details and attendance records.
- **Services:** Handle authentication and local session persistence.
- **Bindings:** Register controllers and dependencies for the relevant screens.
- **Routes:** Navigate users to the appropriate dashboard based on their role.

The application follows a feature-based folder structure to keep related screens, controllers, models, and services organized.

## 4. Demo Login Credentials

Use these demo accounts to test the role-based workflow, if they are configured in the current build.

| Role | Email | Password |
|---|---|---|
| Admin | `admin@test.com` | `Admin@123` |
| Senior Staff | `senior@test.com` | `Senior@123` |
| Staff | `staff@test.com` | `Staff@123` |

## 5. Testing the Three Roles

### Admin

1. Log in using the Admin credentials.
2. Verify that the Admin dashboard opens.
3. Check that attendance records for all employees are visible.
4. Test employee and date filters, where available.
5. Verify user management functionality.
6. Check that the Admin can access personal attendance.
7. Log out and confirm that the login screen appears.

**Expected result:** Admin can access the available team-wide attendance and user management features.

### Senior Staff

1. Log in using the Senior Staff credentials.
2. Verify that the Senior Staff dashboard opens.
3. Check personal attendance and attendance history.
4. Open team attendance.
5. Verify that Staff attendance is visible.
6. Confirm that Admin and other Senior Staff attendance records are not accessible.
7. Confirm that user management is unavailable.
8. Log out.

**Expected result:** Senior Staff can view personal attendance and Staff attendance only.

### Staff

1. Log in using the Staff credentials.
2. Verify that the Staff dashboard opens.
3. Check in and confirm that the attendance time is recorded.
4. Check out and confirm that the check-out time is recorded.
5. Review personal attendance history.
6. Verify that duplicate check-in or check-out actions are prevented.
7. Confirm that other employees' attendance and user management are inaccessible.
8. Log out.

**Expected result:** Staff can manage and view only their own attendance records.

## 6. Attendance Validation

During testing, verify the following:

- Check-in and check-out times are recorded correctly.
- Check-out is allowed only after check-in.
- Duplicate daily attendance records are prevented.
- Each record belongs to the correct employee.
- Attendance history is sorted with the newest records first.
- Dashboard counts reflect the available attendance data.
- Session restoration and logout behave correctly.

## 7. Notes

This project is intended for development and demonstration. Verify the configured authentication and storage implementation before using it with real employee data.

