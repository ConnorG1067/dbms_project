import 'package:dbms_project/Widgets/dashboard_widgets.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({Key? key}) : super(key: key);

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {

  List<Widget> cardList = [


  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(width: 340, height: 340, child: DashboardWidgets.dashboardCard(160, 250, 'Weight')),
                  SizedBox(width: 340, height: 340, child: DashboardWidgets.dashboardCard(1500, 3200, 'Calories')),
                  SizedBox(width: 340, height: 340, child: DashboardWidgets.dashboardCard(3700, 10000, 'Steps')),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(width: 340, height: 340, child: DashboardWidgets.dashboardCard(500, 3700, 'Hydration')),
                  SizedBox(width: 340, height: 340, child: DashboardWidgets.dashboardCard(30, 180, 'Active Minutes')),
                  SizedBox(width: 340, height: 340, child: DashboardWidgets.dashboardCard(1, 8, 'Sleep Duration')),
                ],
              )
            ],
          ),
        ),
        TableCalendar(
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: DateTime.now(),
        )
      ],
    );
  }
}
