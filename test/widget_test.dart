import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mlm_attendence/main.dart';

import 'package:mlm_attendence/features/auth/controllers/auth_controller.dart';

void main() {
  // Initialize GetX bindings required by the app
  Get.lazyPut<AuthController>(() => AuthController(), fenix: true);

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MLMAttendenceApp());

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}