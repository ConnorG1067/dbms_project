import 'package:dbms_project/features/admin_home/billing.dart';
import 'package:dbms_project/features/admin_home/manage_rooms.dart';
import 'package:dbms_project/features/admin_home/session_management.dart';
import 'package:dbms_project/features/home/main_dashboard.dart';
import 'package:dbms_project/features/home/user_settings.dart';
import 'package:dbms_project/features/home/daily_log.dart';
import 'package:dbms_project/features/admin_home/equipment_maintenance.dart';
import 'package:dbms_project/features/home/workshops.dart';
import 'package:dbms_project/features/trainer_home/complete_session_page.dart';
import 'package:dbms_project/features/trainer_home/member_page.dart';
import 'package:dbms_project/features/trainer_home/trainer_dashboard.dart';
import '../../util/globals.dart';

import 'package:flutter/material.dart';
import 'package:side_navigation/side_navigation.dart';
import 'package:intl/intl.dart';

class SideBarNav extends StatefulWidget {
  const SideBarNav({
    Key? key,
  }) : super(key: key);

  @override
  _MemberDashboardState createState() => _MemberDashboardState();
}

class _MemberDashboardState extends State<SideBarNav> {
  /// Views to display
  List<Widget> views = (Globals.accountType == 'member') ? [
    const MainDashboard(),
    const WorkShops(),
    const UserSettings(),
    const DailyLogPage(),
    if(Globals.accountType == 'admin')
    const EquipmentMaintenancePage(),
  ] : (Globals.accountType == 'trainer') ? [
    const TrainerDashboard(),
    const MemberProfilePage(),
    const CompletedSessionPage()
  ] : [
    const ManageRooms(),
    const EquipmentMaintenancePage(),
    const SessionManagement(),
    const BillingSystem()
  ];

  List<SideNavigationBarItem> sideBarItems = (Globals.accountType == 'member') ? [
    const SideNavigationBarItem(
      icon: Icons.dashboard,
      label: 'Dashboard',
    ),
    const SideNavigationBarItem(
      icon: Icons.calendar_today,
      label: 'Workshops',
    ),
    const SideNavigationBarItem(
      icon: Icons.settings,
      label: 'Settings',
    ),
    const SideNavigationBarItem(
        icon: Icons.bookmark_add_outlined,
        label: 'Daily Log'
    ),
    if(Globals.accountType == "admin")
      const SideNavigationBarItem(
          icon: Icons.settings,
          label: 'Equipment Maintenance'
      ),
  ] : (Globals.accountType == 'trainer') ? [
    const SideNavigationBarItem(
        icon: Icons.dashboard,
        label: 'Dashboard'
    ),
    const SideNavigationBarItem(
        icon: Icons.account_circle,
        label: 'Member Profiles'
    ),
    const SideNavigationBarItem(
        icon: Icons.check,
        label: 'Completed Sessions'
    ),
  ] : [
    const SideNavigationBarItem(
        icon: Icons.room,
        label: 'Rooms'
    ),
    const SideNavigationBarItem(
        icon: Icons.add_business,
        label: 'Equipment Management'
    ),
    const SideNavigationBarItem(
        icon: Icons.calendar_month,
        label: 'Session Management'
    ),
    const SideNavigationBarItem(
        icon: Icons.price_check,
        label: 'Billing'
    ),
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          /// Pretty similar to the BottomNavigationBar!
          SideNavigationBar(
            theme: SideNavigationBarTheme(
                togglerTheme: const SideNavigationBarTogglerTheme(),
                itemTheme: SideNavigationBarItemTheme.standard(),
                dividerTheme: const SideNavigationBarDividerTheme(
                  mainDividerColor: Colors.grey,
                  showFooterDivider: false,
                  showHeaderDivider: true,
                  showMainDivider: true,
                )),
            selectedIndex: selectedIndex,
            header: SideNavigationBarHeader(
                title: Text(Globals.currentAccount['accounts']['firstname']),
                image: const CircleAvatar(
                  child: Icon(Icons.sports_gymnastics),
                ),
                subtitle: Text(
                  DateFormat('yyyy-MM-dd').format(DateTime.now()),
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                )),
            items: sideBarItems,
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),

          /// Make it take the rest of the available width
          Expanded(
            child: views.elementAt(selectedIndex),
          )
        ],
      ),
    );
  }
}
