import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/constants/app_colors.dart';
import '../../../common/widgets/status_chip.dart';
import '../../attendance/controllers/attendance_controller.dart';
import '../../attendance/models/attendance_record.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/models/app_user.dart';

class StaffDashboard extends StatefulWidget {
  const StaffDashboard({super.key});
  @override
  State<StaffDashboard> createState() => _StaffDashboardState();
}

class _StaffDashboardState extends State<StaffDashboard> {
  late AttendanceController data;
  int tab = 0;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<AttendanceController>()) {
      Get.put(AttendanceController(), permanent: true);
    }
    data = Get.find<AttendanceController>();
    data.clearFilters();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final role = Get.find<AuthController>().currentUser.value.role;
      if (role != UserRole.staff) {
        if (role == UserRole.admin) {
          Get.offNamed('/admin-dashboard');
        } else if (role == UserRole.seniorStaff) {
          Get.offNamed('/senior-staff-dashboard');
        } else {
          Get.offNamed('/login');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final compact = MediaQuery.sizeOf(context).width < 760;
      final user = data.signedInEmployee;
      final record = data.myTodayRecord;
      final checkedIn = record.checkInTime != null;
      final checkedOut = record.checkOutTime != null;

      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: const Text(
            'Attendly',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          actions: [
            IconButton(
              tooltip: 'Sign out',
              onPressed: _logout,
              icon: const Icon(Icons.logout_rounded, color: AppColors.primary),
            ),
          ],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(compact ? 16 : 30),
              child: tab == 0
                  ? _dashboard(
                      compact,
                      user.name,
                      record,
                      checkedIn,
                      checkedOut,
                    )
                  : _history(data.ownHistory),
            ),
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: tab,
          onDestinationSelected: (value) => setState(() => tab = value),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.space_dashboard_rounded),
              label: 'My day',
            ),
            NavigationDestination(
              icon: Icon(Icons.history_rounded),
              label: 'History',
            ),
          ],
        ),
      );
    });
  }

  Widget _dashboard(
    bool compact,
    String name,
    AttendanceRecord record,
    bool checkedIn,
    bool checkedOut,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(compact ? 23 : 32),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF183D55), Color(0xFF147D83), Color(0xFF24A59A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1C168D8D),
                blurRadius: 25,
                offset: Offset(0, 11),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'STAFF WORKSPACE',
                style: TextStyle(
                  color: Color(0xFFC8F6F0),
                  fontSize: 10,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 17),
              Text(
                'Hello, $name',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: compact ? 25 : 31,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -.6,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Make today count. Your attendance is all in one place.',
                style: TextStyle(
                  color: Colors.white.withOpacity(.83),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 21),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _today(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _heading(
          'Today’s attendance',
          'Your check-in status and recorded times',
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(compact ? 18 : 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _statusColor(
                        checkedIn,
                        checkedOut,
                      ).withOpacity(.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      _statusIcon(checkedIn, checkedOut),
                      color: _statusColor(checkedIn, checkedOut),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Attendance status',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          checkedOut
                              ? 'Day completed'
                              : checkedIn
                              ? 'You are checked in'
                              : 'Not checked in yet',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusChip(label: record.status, color: record.statusColor),
                ],
              ),
              const SizedBox(height: 22),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth < 430 ? 1 : 2;
                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: columns,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: columns == 1 ? 4.2 : 2.25,
                    children: [
                      _timeCard(
                        'CHECK-IN TIME',
                        record.timeText(record.checkInTime),
                        Icons.login_rounded,
                        const Color(0xFF16865B),
                      ),
                      _timeCard(
                        'CHECK-OUT TIME',
                        record.timeText(record.checkOutTime),
                        Icons.logout_rounded,
                        AppColors.primary,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              if (!checkedIn)
                _actionButton(
                  'Check in now',
                  Icons.login_rounded,
                  const Color(0xFF16865B),
                  data.checkIn,
                )
              else if (!checkedOut)
                _actionButton(
                  'Check out',
                  Icons.logout_rounded,
                  AppColors.primary,
                  data.checkOut,
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF7F0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFF16865B),
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Attendance completed for today',
                        style: TextStyle(
                          color: Color(0xFF16865B),
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Recent history',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () => setState(() => tab = 1),
              icon: const Icon(Icons.arrow_forward_rounded, size: 16),
              label: const Text('View all'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _recordList(data.ownHistory.take(3).toList()),
      ],
    );
  }

  Widget _actionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback action,
  ) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: action,
        icon: Icon(icon),
        label: Text(label),
        style: FilledButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
      ),
    );
  }

  Widget _timeCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(.1),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 8,
                    letterSpacing: .6,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _history(List<AttendanceRecord> records) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _heading(
          'My attendance history',
          'Your records are sorted from newest to oldest',
        ),
        const SizedBox(height: 18),
        _recordList(records),
      ],
    );
  }

  Widget _recordList(List<AttendanceRecord> records) {
    if (records.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(30),
        child: Center(
          child: Text(
            'No attendance history yet',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: records
            .map(
              (record) => Container(
                margin: const EdgeInsets.only(bottom: 9),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBFCFE),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_rounded,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            record.dateText,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        StatusChip(
                          label: record.status,
                          color: record.statusColor,
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 11),
                      child: Divider(height: 1),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _historyTime(
                            'CHECK-IN',
                            record.timeText(record.checkInTime),
                          ),
                        ),
                        Expanded(
                          child: _historyTime(
                            'CHECK-OUT',
                            record.timeText(record.checkOutTime),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _historyTime(String title, String value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 8,
          color: AppColors.textSecondary,
          letterSpacing: .7,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 5),
      Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
      ),
    ],
  );
  Widget _heading(String title, String subtitle) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
      ),
      const SizedBox(height: 5),
      Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
    ],
  );
  Color _statusColor(bool checkedIn, bool checkedOut) => checkedOut
      ? const Color(0xFF16865B)
      : checkedIn
      ? const Color(0xFF2878D0)
      : const Color(0xFFE09A36);
  IconData _statusIcon(bool checkedIn, bool checkedOut) => checkedOut
      ? Icons.task_alt_rounded
      : checkedIn
      ? Icons.pending_actions_rounded
      : Icons.access_time_rounded;
  String _today() {
    final now = DateTime.now();
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }

  void _logout() async {
    final yes = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Sign out?'),
        content: const Text('End your current session?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
    if (yes == true) Get.find<AuthController>().logout();
  }
}
