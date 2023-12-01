import 'package:dbms_project/features/home/main_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:side_navigation/side_navigation.dart';
import 'package:intl/intl.dart';
import '../../util/globals.dart';

class SideBarNav extends StatefulWidget {
  const SideBarNav({
    Key? key,
  }) : super(key: key);

  @override
  _MemberDashboardState createState() => _MemberDashboardState();
}

class _MemberDashboardState extends State<SideBarNav> {
  /// Views to display
  List<Widget> views =  [
    MainDashboard(),
    Center(
      child: Text('Routines'),
    ),
    Center(
      child: Text('Achievements'),
    ),
    Center(
      child: Text('Schedule'),
    ),
    Center(
      child: Text('Account'),
    ),
    Center(
      child: Text('Settings'),
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
                image: CircleAvatar(
                  child: Icon(Icons.sports_gymnastics),
                ),
                subtitle: Text(
                DateFormat('yyyy-MM-dd').format(DateTime.now()),
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                )),
            items: const [
              SideNavigationBarItem(
                icon: Icons.dashboard,
                label: 'Dashboard',
              ),
              SideNavigationBarItem(
                icon: Icons.alarm_outlined,
                label: 'Routines',
              ),
              SideNavigationBarItem(
                icon: Icons.plus_one,
                label: 'Achievements',
              ),
              SideNavigationBarItem(
                icon: Icons.calendar_today,
                label: 'Schedule',
              ),
              SideNavigationBarItem(
                icon: Icons.person,
                label: 'Account',
              ),
              SideNavigationBarItem(
                icon: Icons.settings,
                label: 'Settings',
              ),
            ],
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
