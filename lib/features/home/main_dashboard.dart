import 'package:dbms_project/Widgets/dashboard_widgets.dart';
import 'package:flutter/material.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({Key? key}) : super(key: key);

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {

  List<Widget> cardList = [
    DashboardWidgets.dashboardCard(160, 250, 'Weight'),
    DashboardWidgets.dashboardCard(1500, 3200, 'Calories'),
    DashboardWidgets.dashboardCard(3700, 10000, 'Steps'),
    DashboardWidgets.dashboardCard(500, 3700, 'Hydration')

  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        physics: const AlwaysScrollableScrollPhysics(),
        crossAxisCount: 3,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 8.0,
        children: cardList
    );
  }
}
