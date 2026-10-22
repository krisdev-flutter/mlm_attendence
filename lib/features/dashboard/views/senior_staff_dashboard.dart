import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/constants/app_colors.dart';
import '../../../common/widgets/status_chip.dart';
import '../../attendance/controllers/attendance_controller.dart';
import '../../attendance/models/attendance_record.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/models/app_user.dart';
import '../models/employee.dart';

class SeniorStaffDashboard extends StatefulWidget {
  const SeniorStaffDashboard({super.key});
  @override
  State<SeniorStaffDashboard> createState() => _SeniorStaffDashboardState();
}

class _SeniorStaffDashboardState extends State<SeniorStaffDashboard> {
  late AttendanceController data;
  final search = TextEditingController();
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
      if (role != UserRole.seniorStaff) {
        if (role == UserRole.admin) {
          Get.offNamed('/admin-dashboard');
        } else if (role == UserRole.staff) {
          Get.offNamed('/staff-dashboard');
        } else {
          Get.offNamed('/login');
        }
      }
    });
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final compact = MediaQuery.sizeOf(context).width < 760;
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
              onPressed: _logout,
              tooltip: 'Sign out',
              icon: const Icon(Icons.logout_rounded, color: AppColors.primary),
            ),
          ],
        ),
        drawer: compact ? Drawer(child: _drawer()) : null,
        body: Row(
          children: [
            if (!compact) SizedBox(width: 230, child: _sidebar()),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(compact ? 16 : 28),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1300),
                    child: tab == 0
                        ? _overview(compact)
                        : tab == 1
                        ? _attendance(compact)
                        : _history(data.ownHistory),
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: compact
            ? NavigationBar(
                selectedIndex: tab,
                onDestinationSelected: (value) => setState(() => tab = value),
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.space_dashboard_rounded),
                    label: 'Overview',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.fact_check_rounded),
                    label: 'Staff',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.history_rounded),
                    label: 'My history',
                  ),
                ],
              )
            : null,
      );
    });
  }

  Widget _sidebar() => Container(
    color: const Color(0xFF111D37),
    child: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _brand(),
          const Padding(
            padding: EdgeInsets.fromLTRB(22, 0, 18, 12),
            child: Text(
              'WORKSPACE',
              style: TextStyle(
                color: Color(0xFF7F8EAF),
                fontSize: 10,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          _nav(0, Icons.space_dashboard_rounded, 'Team overview'),
          _nav(1, Icons.fact_check_rounded, 'Staff attendance'),
          _nav(2, Icons.history_rounded, 'My history'),
          const Spacer(),
          _profile(),
          const SizedBox(height: 18),
        ],
      ),
    ),
  );

  Widget _drawer() => Container(
    color: const Color(0xFF111D37),
    child: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _brand(),
          _nav(0, Icons.space_dashboard_rounded, 'Team overview'),
          _nav(1, Icons.fact_check_rounded, 'Staff attendance'),
          _nav(2, Icons.history_rounded, 'My history'),
        ],
      ),
    ),
  );

  Widget _brand() => const Padding(
    padding: EdgeInsets.all(22),
    child: Row(
      children: [
        Icon(Icons.bolt_rounded, color: Color(0xFF82A0FF), size: 34),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Attendly',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'SENIOR WORKSPACE',
              style: TextStyle(
                color: Color(0xFF94A3C5),
                fontSize: 9,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _nav(int index, IconData icon, String label) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        setState(() => tab = index);
        if (MediaQuery.sizeOf(context).width < 760 && Navigator.canPop(context))
          Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: tab == index ? const Color(0xFF2A4073) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: tab == index ? Colors.white : const Color(0xFF9DABC8),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: tab == index ? Colors.white : const Color(0xFFC3CDE0),
                fontWeight: tab == index ? FontWeight.w700 : FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _profile() {
    final email =
        Get.find<AuthController>().currentUser.value.email ?? 'senior@test.com';
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1B2A4A),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xFF7057D9),
              child: Icon(Icons.workspace_premium_rounded, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Senior Staff',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF9EACCB),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _overview(bool compact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _hero(compact),
        const SizedBox(height: 26),
        _heading(
          'Staff attendance overview',
          'Only staff accounts are included in these figures',
        ),
        const SizedBox(height: 15),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth < 500
                ? 1
                : constraints.maxWidth < 850
                ? 2
                : 3;
            const gap = 14.0;
            final width =
                (constraints.maxWidth - gap * (columns - 1)) / columns;
            final metrics = [
              _Metric(
                'Total staff',
                '${data.staffCount}',
                Icons.groups_rounded,
                const Color(0xFF4168D9),
              ),
              _Metric(
                'Checked in today',
                '${data.staffCheckedInCount}',
                Icons.how_to_reg_rounded,
                const Color(0xFF16865B),
              ),
              _Metric(
                'Not checked in',
                '${data.staffNotCheckedInCount}',
                Icons.person_off_outlined,
                const Color(0xFFE09A36),
              ),
            ];
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: metrics
                  .map(
                    (metric) =>
                        SizedBox(width: width, child: _metricCard(metric)),
                  )
                  .toList(),
            );
          },
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Today’s staff activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            TextButton(
              onPressed: () => setState(() => tab = 1),
              child: const Text('View all'),
            ),
          ],
        ),
        const SizedBox(height: 13),
        _recordList(
          data.todayRecords
              .where((record) => record.role == EmployeeRole.staff)
              .take(6)
              .toList(),
        ),
      ],
    );
  }

  Widget _hero(bool compact) => Container(
    width: double.infinity,
    padding: EdgeInsets.all(compact ? 22 : 30),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF352A80), Color(0xFF6854D9), Color(0xFF8B7AEC)],
      ),
      borderRadius: BorderRadius.circular(23),
      boxShadow: const [
        BoxShadow(
          color: Color(0x1F6854D9),
          blurRadius: 25,
          offset: Offset(0, 11),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SENIOR STAFF WORKSPACE',
          style: TextStyle(
            color: Color(0xFFE0DBFF),
            fontSize: 10,
            letterSpacing: 1.4,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 17),
        Text(
          'Your team, at a glance',
          style: TextStyle(
            color: Colors.white,
            fontSize: compact ? 24 : 30,
            fontWeight: FontWeight.w800,
            letterSpacing: -.6,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Monitor staff check-ins and daily attendance from one clear view.',
          style: TextStyle(
            color: Colors.white.withOpacity(.83),
            fontSize: 13,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 9,
          runSpacing: 9,
          children: [
            _tag(Icons.groups_rounded, '${data.staffCount} staff members'),
            _tag(Icons.calendar_today_rounded, _today()),
          ],
        ),
      ],
    ),
  );

  Widget _tag(IconData icon, String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(.13),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: Colors.white),
        const SizedBox(width: 7),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );

  Widget _metricCard(_Metric metric) => Container(
    padding: const EdgeInsets.all(19),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: metric.color.withOpacity(.1),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(metric.icon, color: metric.color),
        ),
        const SizedBox(height: 16),
        Text(
          metric.value,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          metric.title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    ),
  );

  Widget _attendance(bool compact) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _heading(
        'Staff attendance records',
        'Admin and Senior Staff records are excluded',
      ),
      const SizedBox(height: 17),
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: search,
              onChanged: data.updateSearch,
              decoration: InputDecoration(
                hintText: 'Search staff name or ID',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: () async {
              final now = DateTime.now();
              final date = await showDatePicker(
                context: context,
                initialDate: data.selectedDate.value ?? now,
                firstDate: DateTime(now.year - 5),
                lastDate: DateTime(now.year + 1),
              );
              data.updateDate(date);
            },
            icon: const Icon(Icons.calendar_month_rounded, size: 17),
            label: Obx(
              () => Text(
                data.selectedDate.value == null
                    ? 'Date'
                    : '${data.selectedDate.value!.day}/${data.selectedDate.value!.month}/${data.selectedDate.value!.year}',
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 14),
      _recordList(
        data.visibleRecords
            .where((record) => record.role == EmployeeRole.staff)
            .toList(),
      ),
    ],
  );

  Widget _history(List<AttendanceRecord> records) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _heading('My attendance history', 'Your records, latest first'),
      const SizedBox(height: 17),
      _recordList(records),
    ],
  );

  Widget _recordList(List<AttendanceRecord> records) {
    if (records.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(35),
        child: Center(
          child: Text(
            'No attendance records found',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(13),
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
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBFCFE),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xFFEAF0FF),
                          child: Text(
                            _initials(record.employeeName),
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                record.employeeName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${record.dateText} • ${record.role.displayName}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        StatusChip(
                          label: record.status,
                          color: record.statusColor,
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(height: 1),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _time(
                            'CHECK-IN',
                            record.timeText(record.checkInTime),
                          ),
                        ),
                        Expanded(
                          child: _time(
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

  Widget _time(String label, String value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 8,
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w800,
          letterSpacing: .7,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        value,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
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
  String _initials(String name) {
    final parts = name.split(' ');
    return parts.length > 1
        ? '${parts.first[0]}${parts.last[0]}'.toUpperCase()
        : name[0].toUpperCase();
  }

  String _today() {
    final now = DateTime.now();
    return '${now.day}/${now.month}/${now.year}';
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

class _Metric {
  const _Metric(this.title, this.value, this.icon, this.color);
  final String title;
  final String value;
  final IconData icon;
  final Color color;
}
