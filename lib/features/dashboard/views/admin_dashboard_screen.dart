import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/constants/app_colors.dart';
import '../../../common/widgets/role_chip.dart';
import '../../../common/widgets/status_chip.dart';
import '../../attendance/controllers/attendance_controller.dart';
import '../../attendance/models/attendance_record.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/models/app_user.dart';
import '../bindings/admin_dashboard_binding.dart';
import '../controllers/admin_dashboard_controller.dart';
import '../models/employee.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});
  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  late final AttendanceController data;
  final searchController = TextEditingController();
  final navLabels = const ['Overview', 'Attendance records', 'User management', 'My history'];
  final navIcons = const [Icons.space_dashboard_rounded, Icons.fact_check_rounded, Icons.groups_rounded, Icons.history_rounded];

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<AttendanceController>()) Get.put(AttendanceController(), permanent: true);
    data = Get.find<AttendanceController>();
    data.activeTab.value = 0;
    data.clearFilters();
    if (!Get.isRegistered<AdminDashboardController>()) AdminDashboardBinding().dependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final role = Get.find<AuthController>().currentUser.value.role;
      if (role != UserRole.admin) {
        if (role == UserRole.seniorStaff) {
          Get.offNamed('/senior-staff-dashboard');
        } else if (role == UserRole.staff) {
          Get.offNamed('/staff-dashboard');
        } else {
          Get.offNamed('/login');
        }
      }
    });
  }

  @override
  void dispose() { searchController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final width = MediaQuery.sizeOf(context).width;
      final compact = width < 760;
      final selected = data.activeTab.value.clamp(0, 3).toInt();
      return Scaffold(
        backgroundColor: AppColors.background,
        drawer: compact ? Drawer(child: _sidebar(selected, true)) : null,
        body: Row(children: [
          if (!compact) SizedBox(width: width < 1100 ? 218 : 250, child: _sidebar(selected, false)),
          Expanded(child: Column(children: [
            _topBar(context, compact),
            Expanded(child: SingleChildScrollView(
              padding: EdgeInsets.all(compact ? 16 : width < 1100 ? 24 : 32),
              child: Center(child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1500),
                child: selected == 0 ? _overview(compact, width) : selected == 1 ? _recordsScreen(compact) : selected == 2 ? _usersScreen(compact) : _historyScreen(compact),
              )),
            )),
          ])),
        ]),
        bottomNavigationBar: compact ? NavigationBar(
          selectedIndex: selected,
          onDestinationSelected: (value) => data.activeTab.value = value,
          destinations: List.generate(navLabels.length, (i) => NavigationDestination(icon: Icon(navIcons[i]), label: navLabels[i].replaceAll(' records', '').replaceAll(' management', ''))),
        ) : null,
      );
    });
  }

  Widget _sidebar(int selected, bool inDrawer) => Container(
    color: const Color(0xFF111D37),
    child: SafeArea(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Padding(padding: const EdgeInsets.fromLTRB(22, 22, 16, 28), child: Row(children: [
        Container(width: 42, height: 42, decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF82A0FF), Color(0xFF4267E8)]), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 25)),
        const SizedBox(width: 12), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Attendly', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -.5)), SizedBox(height: 3), Text('WORKFORCE HUB', style: TextStyle(color: Color(0xFF94A3C5), fontSize: 9, letterSpacing: 1.5, fontWeight: FontWeight.w700))])),
      ])),
      const Padding(padding: EdgeInsets.fromLTRB(22, 0, 18, 12), child: Text('WORKSPACE', style: TextStyle(color: Color(0xFF7F8EAF), fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.w800))),
      ...List.generate(navLabels.length, (i) => Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), child: InkWell(
        borderRadius: BorderRadius.circular(13), onTap: () { data.activeTab.value = i; if (inDrawer) Navigator.of(context).pop(); },
        child: AnimatedContainer(duration: const Duration(milliseconds: 180), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14), decoration: BoxDecoration(color: selected == i ? const Color(0xFF2A4073) : Colors.transparent, borderRadius: BorderRadius.circular(13), border: Border.all(color: selected == i ? const Color(0xFF435F9F) : Colors.transparent)), child: Row(children: [Icon(navIcons[i], color: selected == i ? Colors.white : const Color(0xFF9DABC8), size: 20), const SizedBox(width: 13), Expanded(child: Text(navLabels[i], style: TextStyle(color: selected == i ? Colors.white : const Color(0xFFC3CDE0), fontSize: 12, fontWeight: selected == i ? FontWeight.w700 : FontWeight.w500))), if (selected == i) const Icon(Icons.circle, size: 6, color: Color(0xFF8DA8FF))])),
      ))),
      const Spacer(),
      Obx(() { final email = Get.find<AuthController>().currentUser.value.email ?? 'admin@test.com'; return Padding(padding: const EdgeInsets.all(14), child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFF1B2A4A), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF2A3A5B))), child: Row(children: [CircleAvatar(backgroundColor: const Color(0xFF4567E8), child: Text(email[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800))), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Administrator', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)), const SizedBox(height: 3), Text(email, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF9EACCB), fontSize: 10))]))]))); }),
      Padding(padding: const EdgeInsets.fromLTRB(18, 0, 18, 18), child: Text('MLM Attendance  •  v1.0', style: TextStyle(color: Colors.white.withOpacity(.42), fontSize: 10))),
    ])),
  );

  Widget _topBar(BuildContext context, bool compact) => Container(height: 74, padding: EdgeInsets.symmetric(horizontal: compact ? 10 : 28), decoration: const BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: AppColors.border))), child: Row(children: [
    if (compact) Builder(builder: (context) => IconButton(onPressed: () => Scaffold.of(context).openDrawer(), icon: const Icon(Icons.menu_rounded))),
    Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(navLabels[data.activeTab.value.clamp(0, 3).toInt()], style: const TextStyle(fontSize: 17, color: AppColors.textPrimary, fontWeight: FontWeight.w800)), if (!compact) const Padding(padding: EdgeInsets.only(top: 3), child: Text('Workspace  /  Administration', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)))])),
    if (!compact) Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), decoration: BoxDecoration(color: const Color(0xFFF6F8FC), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: Row(children: [const Icon(Icons.calendar_month_rounded, size: 16, color: AppColors.textSecondary), const SizedBox(width: 8), Text(_todayLabel(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700))])),
    const SizedBox(width: 10), IconButton(tooltip: 'Sign out', onPressed: _logout, icon: const Icon(Icons.logout_rounded, color: AppColors.primary)),
  ]));

  Widget _overview(bool compact, double width) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    _hero(compact), const SizedBox(height: 28), _heading('Workforce overview', 'A real-time snapshot of your team today'), const SizedBox(height: 15),
    LayoutBuilder(builder: (context, c) { final columns = c.maxWidth < 520 ? 1 : c.maxWidth < 850 ? 2 : c.maxWidth < 1250 ? 3 : 5; final gap = 14.0; final itemWidth = (c.maxWidth - gap * (columns - 1)) / columns; final cards = [
      _Metric('Total users', '${data.totalUsers}', 'All registered accounts', Icons.groups_rounded, const Color(0xFF4168D9)),
      _Metric('Staff members', '${data.staffCount}', 'Staff accounts', Icons.badge_outlined, const Color(0xFF159D88)),
      _Metric('Senior staff', '${data.seniorCount}', 'Senior accounts', Icons.workspace_premium_outlined, const Color(0xFF8863D9)),
      _Metric('Checked in', '${data.checkedInCount}', 'Attendance started', Icons.how_to_reg_rounded, const Color(0xFF1C9B62)),
      _Metric('Not checked in', '${data.notCheckedInCount}', 'Awaiting attendance', Icons.person_off_outlined, const Color(0xFFE09A36)),
    ]; return Wrap(spacing: gap, runSpacing: gap, children: cards.map((card) => SizedBox(width: itemWidth, child: _metricCard(card))).toList()); }),
    const SizedBox(height: 30), _heading('Recent attendance', 'Latest attendance activity across all roles', trailing: TextButton.icon(onPressed: () => data.activeTab.value = 1, icon: const Icon(Icons.arrow_forward_rounded, size: 16), label: const Text('View all'))), const SizedBox(height: 14), _recordPanel(data.todayRecords.take(7).toList(), compact),
  ]);

  Widget _hero(bool compact) => Container(width: double.infinity, padding: EdgeInsets.all(compact ? 22 : 30), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF253F85), Color(0xFF4168D9), Color(0xFF5D7BEB)], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(24), boxShadow: const [BoxShadow(color: Color(0x203156D8), blurRadius: 26, offset: Offset(0, 12))]), child: Stack(children: [Positioned(right: -8, top: -45, child: Container(width: compact ? 105 : 170, height: compact ? 105 : 170, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(.1), width: 24)))), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.white.withOpacity(.14), borderRadius: BorderRadius.circular(20)), child: const Text('ADMIN WORKSPACE', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1.3)),), const SizedBox(height: 18), Text('Good ${DateTime.now().hour < 12 ? 'morning' : DateTime.now().hour < 17 ? 'afternoon' : 'evening'}, Admin', style: TextStyle(color: Colors.white, fontSize: compact ? 24 : 30, fontWeight: FontWeight.w800, letterSpacing: -.7)), const SizedBox(height: 9), ConstrainedBox(constraints: const BoxConstraints(maxWidth: 560), child: Text('Keep your workforce moving. Review attendance, monitor daily check-ins, and manage your team from one place.', style: TextStyle(color: Colors.white.withOpacity(.82), fontSize: compact ? 12 : 14, height: 1.6))), const SizedBox(height: 22), Wrap(spacing: 9, runSpacing: 9, children: [_heroTag(Icons.schedule_rounded, 'Today • ${_todayLabel()}'), _heroTag(Icons.verified_user_outlined, 'Admin control')])])])) ;

  Widget _heroTag(IconData icon, String label) => Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9), decoration: BoxDecoration(color: Colors.white.withOpacity(.13), borderRadius: BorderRadius.circular(11)), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 15, color: Colors.white), const SizedBox(width: 7), Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600))]));

  Widget _metricCard(_Metric m) => Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(19), border: Border.all(color: AppColors.border), boxShadow: const [BoxShadow(color: Color(0x060D2148), blurRadius: 18, offset: Offset(0, 5))]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Container(width: 43, height: 43, decoration: BoxDecoration(color: m.color.withOpacity(.1), borderRadius: BorderRadius.circular(14)), child: Icon(m.icon, color: m.color, size: 21)), const Spacer(), Icon(Icons.trending_up_rounded, color: m.color.withOpacity(.65), size: 18)]), const SizedBox(height: 17), Text(m.value, style: const TextStyle(fontSize: 29, color: AppColors.textPrimary, fontWeight: FontWeight.w800, letterSpacing: -1)), const SizedBox(height: 5), Text(m.title, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, fontWeight: FontWeight.w700)), const SizedBox(height: 5), Text(m.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary))]));

  Widget _recordsScreen(bool compact) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_heading('Attendance records', 'Review check-ins and check-outs across the workforce'), const SizedBox(height: 18), _filters(compact, allowRole: true), const SizedBox(height: 14), _recordPanel(data.visibleRecords, compact)]);

  Widget _historyScreen(bool compact) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_heading('My attendance history', 'Your daily attendance records, newest first'), const SizedBox(height: 18), _recordPanel(data.ownHistory, compact)]);

  Widget _usersScreen(bool compact) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_heading('User management', 'Predefined users and their assigned access roles'), const SizedBox(height: 18), Container(width: double.infinity, padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.border)), child: Column(children: data.employees.map((e) => _userRow(e, compact)).toList()) )]);

  Widget _userRow(Employee e, bool compact) => Container(padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 5), decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFEEF1F6)))), child: Row(children: [CircleAvatar(radius: 20, backgroundColor: const Color(0xFFEAF0FF), child: Text(e.initials, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 12))), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(e.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textPrimary)), const SizedBox(height: 4), Text(e.email, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary))])), if (!compact) Padding(padding: const EdgeInsets.only(right: 14), child: Text(e.id, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary))), RoleChip(role: e.role)]));

  Widget _filters(bool compact, {required bool allowRole}) => Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17), border: Border.all(color: AppColors.border)), child: LayoutBuilder(builder: (context, c) { final full = c.maxWidth < 520; final searchWidth = full ? c.maxWidth : c.maxWidth < 850 ? 250.0 : 320.0; return Wrap(spacing: 10, runSpacing: 10, crossAxisAlignment: WrapCrossAlignment.center, children: [SizedBox(width: searchWidth, child: TextField(onChanged: data.updateSearch, decoration: _inputDecoration('Search employee name or ID', Icons.search_rounded))), SizedBox(width: full ? c.maxWidth : 180, child: OutlinedButton.icon(onPressed: () async { final now = DateTime.now(); final picked = await showDatePicker(context: context, initialDate: data.selectedDate.value ?? now, firstDate: DateTime(now.year - 5), lastDate: DateTime(now.year + 1)); data.updateDate(picked); }, icon: const Icon(Icons.calendar_month_rounded, size: 17), label: Obx(() => Text(data.selectedDate.value == null ? 'Filter by date' : _date(data.selectedDate.value!))), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15), foregroundColor: AppColors.textPrimary, side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))), if (allowRole && c.maxWidth > 650) SizedBox(width: 160, child: Obx(() => DropdownButtonFormField<EmployeeRole?>(initialValue: data.selectedRole.value, isExpanded: true, decoration: _inputDecoration('All roles', null), items: [const DropdownMenuItem(value: null, child: Text('All roles')), ...EmployeeRole.values.where((r) => r != EmployeeRole.unknown).map((r) => DropdownMenuItem(value: r, child: Text(r.displayName)))], onChanged: data.updateRole))), OutlinedButton.icon(onPressed: () { searchController.clear(); data.clearFilters(); }, icon: const Icon(Icons.restart_alt_rounded, size: 17), label: const Text('Reset'), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 15), foregroundColor: AppColors.textSecondary, side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))]); }));

  InputDecoration _inputDecoration(String hint, IconData? icon) => InputDecoration(hintText: hint, hintStyle: const TextStyle(fontSize: 12), prefixIcon: icon == null ? null : Icon(icon, size: 18), filled: true, fillColor: const Color(0xFFF7F9FC), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary)));

  Widget _recordPanel(List<AttendanceRecord> records, bool compact) => Container(width: double.infinity, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border), boxShadow: const [BoxShadow(color: Color(0x050D2148), blurRadius: 18, offset: Offset(0, 5))]), child: Column(children: [Padding(padding: const EdgeInsets.fromLTRB(19, 17, 19, 15), child: Row(children: [const Icon(Icons.list_alt_rounded, color: AppColors.primary, size: 19), const SizedBox(width: 9), const Expanded(child: Text('Attendance activity', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.textPrimary))), Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: const Color(0xFFF0F4FF), borderRadius: BorderRadius.circular(20)), child: Text('${records.length} records', style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.w800)))])), const Divider(height: 1, color: Color(0xFFEEF1F6)), if (records.isEmpty) const Padding(padding: EdgeInsets.all(42), child: Column(children: [Icon(Icons.event_busy_rounded, size: 35, color: Color(0xFF9BA8BD)), SizedBox(height: 10), Text('No attendance records found', style: TextStyle(fontWeight: FontWeight.w700)), SizedBox(height: 4), Text('Try changing the search or selected date.', style: TextStyle(color: AppColors.textSecondary, fontSize: 12))])) else if (compact) Padding(padding: const EdgeInsets.all(12), child: Column(children: records.map(_recordTile).toList())) else SingleChildScrollView(scrollDirection: Axis.horizontal, child: ConstrainedBox(constraints: const BoxConstraints(minWidth: 820), child: DataTable(headingRowHeight: 45, dataRowMinHeight: 62, dataRowMaxHeight: 70, horizontalMargin: 20, columnSpacing: 24, headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFD)), columns: const [DataColumn(label: Text('EMPLOYEE')), DataColumn(label: Text('ROLE')), DataColumn(label: Text('DATE')), DataColumn(label: Text('CHECK-IN')), DataColumn(label: Text('CHECK-OUT')), DataColumn(label: Text('STATUS'))], rows: records.map((r) => DataRow(cells: [DataCell(SizedBox(width: 160, child: Row(children: [CircleAvatar(radius: 16, backgroundColor: const Color(0xFFEAF0FF), child: Text(_initials(r.employeeName), style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.w800))), const SizedBox(width: 9), Expanded(child: Text(r.employeeName, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)))]))), DataCell(RoleChip(role: r.role)), DataCell(Text(r.dateText, style: const TextStyle(fontSize: 11))), DataCell(Text(r.timeText(r.checkInTime), style: const TextStyle(fontSize: 11))), DataCell(Text(r.timeText(r.checkOutTime), style: const TextStyle(fontSize: 11))), DataCell(StatusChip(label: r.status, color: r.statusColor))])).toList())))]));

  Widget _recordTile(AttendanceRecord r) => Container(margin: const EdgeInsets.only(bottom: 9), padding: const EdgeInsets.all(13), decoration: BoxDecoration(color: const Color(0xFFFBFCFE), borderRadius: BorderRadius.circular(15), border: Border.all(color: AppColors.border)), child: Column(children: [Row(children: [CircleAvatar(radius: 18, backgroundColor: const Color(0xFFEAF0FF), child: Text(_initials(r.employeeName), style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.w800))), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(r.employeeName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)), const SizedBox(height: 4), Text('${r.dateText} • ${r.role.displayName}', style: const TextStyle(fontSize: 10, color: AppColors.textSecondary))])), StatusChip(label: r.status, color: r.statusColor)]), const Padding(padding: EdgeInsets.symmetric(vertical: 11), child: Divider(height: 1)), Row(children: [Expanded(child: _timeBlock('CHECK-IN', r.timeText(r.checkInTime), Icons.login_rounded)), Expanded(child: _timeBlock('CHECK-OUT', r.timeText(r.checkOutTime), Icons.logout_rounded))]) ]));

  Widget _timeBlock(String label, String value, IconData icon) => Row(children: [Icon(icon, size: 15, color: AppColors.textSecondary), const SizedBox(width: 7), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontSize: 8, letterSpacing: .6, color: AppColors.textSecondary, fontWeight: FontWeight.w800)), const SizedBox(height: 4), Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textPrimary))]))]);

  Widget _heading(String title, String subtitle, {Widget? trailing}) => Row(crossAxisAlignment: CrossAxisAlignment.end, children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -.4)), const SizedBox(height: 5), Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))])), ?trailing]);
  String _initials(String name) { final parts = name.split(' '); return parts.length > 1 ? '${parts.first[0]}${parts.last[0]}'.toUpperCase() : name.substring(0, 1).toUpperCase(); }
  String _todayLabel() { final n = DateTime.now(); const m = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']; return '${n.day} ${m[n.month - 1]} ${n.year}'; }
  String _date(DateTime n) => '${n.day.toString().padLeft(2, '0')}/${n.month.toString().padLeft(2, '0')}/${n.year}';
  void _logout() async { final answer = await Get.dialog<bool>(AlertDialog(title: const Text('Sign out?'), content: const Text('Do you want to end your admin session?'), actions: [TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')), FilledButton(onPressed: () => Get.back(result: true), child: const Text('Sign out'))])); if (answer == true) Get.find<AuthController>().logout(); }
}

class _Metric { const _Metric(this.title, this.value, this.subtitle, this.icon, this.color); final String title, value, subtitle; final IconData icon; final Color color; }
