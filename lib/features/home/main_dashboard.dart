import 'dart:math';

import 'package:dbms_project/Widgets/dashboard_widgets.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting

import '../../util/globals.dart';

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
          onDayLongPressed: (date, events) async {
            List<dynamic> currentSessions = List.from(await Globals.database.query("SELECT * FROM sessions WHERE date=TO_DATE('${DateFormat('yyyy-MM-dd').format(date)}', 'YYYY-MM-DD') AND memberid='${Globals.currentAccount['accounts']['accountid']}'"));

            showDialog(
              context: context,
              builder: (BuildContext context) {
                ExpandableController scheduleExpander = ExpandableController();
                ExpandableController cancelExpander = ExpandableController();
                String sessionType = 'Cardio'; // Default session type
                String startTimeText = "12:00PM";
                String endTimeText = "1:00PM";
                TextEditingController sessionDetailController = TextEditingController();

                List<Widget> generateSessionCards(setState) {
                  return List.generate(currentSessions.length, (index) {
                    Map<String,dynamic> cardInfo = currentSessions[index].toTableColumnMap()['sessions']!;
                    return Row(
                      children: [
                        Card(
                          margin: const EdgeInsets.all(16),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Session Details:',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    Text(cardInfo['sessiondetails']),
                                  ],
                                ),
                                SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Session Type:',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    Text(cardInfo['sessiontype']),
                                  ],
                                ),
                                SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Date:',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    Text(cardInfo['date'].toString()),
                                  ],
                                ),
                                SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Start Time:',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    Text(cardInfo['starttime']),
                                  ],
                                ),
                                SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'End Time:',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    Text(cardInfo['endtime']),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await Globals.database.query("DELETE FROM sessions WHERE date=TO_DATE('${DateFormat('yyyy-MM-dd').format(date)}', 'YYYY-MM-DD') AND starttime='${cardInfo['starttime']}' AND endtime='${cardInfo['endtime']}' AND memberid='${Globals.currentAccount['accounts']['accountid']}' AND trainerid='${cardInfo['trainerid']}'");
                            setState(() => currentSessions.removeAt(index));
                          },
                          child: Text("Cancel Session"),
                        )
                      ],
                    );
                  }
                  );
                }


                return AlertDialog(
                  title: Text('Schedule or cancel a session for ${date.year}-${date.month}-${date.day}'),
                  content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        children: [
                          ExpandableNotifier(
                              child: Expandable(
                                collapsed: Card(
                                  margin: EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
                                        width: 150,
                                        height: 150,
                                        child: Image.network("https://prod-ne-cdn-media.puregym.com/media/819394/gym-workout-plan-for-gaining-muscle_header.jpg?quality=80&mode=pad&width=992")
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          'Schedule a session',
                                          style: TextStyle(fontSize: 18.0),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0),
                                          child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                scheduleExpander.expanded = true;
                                              });
                                            },
                                            child: Text(
                                              'Schedule',
                                              style: TextStyle(color: Colors.blue),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                expanded: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Session Details',
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 8),
                                    Container(
                                      width: 500,
                                      child: TextField(
                                        controller: sessionDetailController,
                                        maxLines: null, // Allows dynamic height
                                        decoration: InputDecoration(
                                          labelText: 'Enter session details',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Text(
                                          'Session Type',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width: 8),
                                        DropdownButton<String>(
                                          value: sessionType,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              sessionType = newValue!;
                                            });
                                          },
                                          items: <String>['Cardio', 'Yoga', 'Strength training']
                                              .map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                        SizedBox(width: 16),
                                        Text(
                                          'Session Time',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width: 8),
                                        ElevatedButton(
                                          onPressed: () async {
                                            // Show time picker and update the selected time
                                            TimeOfDay? selectedTime = await showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now(),
                                            );
                                            setState((){
                                              startTimeText = selectedTime!.format(context);
                                            });
                                          },
                                          child: Text(startTimeText),
                                        ),
                                        SizedBox(
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                                            child: Text("-"),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            // Show time picker and update the selected time
                                            TimeOfDay? selectedTime = await showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now(),

                                            );
                                            setState((){
                                              endTimeText = selectedTime!.format(context);
                                            });
                                          },
                                          child: Text(endTimeText),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                controller: scheduleExpander,
                              )
                          ),
                          SizedBox(height: 20),
                          Padding(padding: EdgeInsets.only(left:16.0), child: Align(child: Text("Sessions for date ${DateFormat('yyyy-MM-dd').format(date)}", style: TextStyle(fontSize: 16)), alignment: Alignment.centerLeft)),
                          Container(
                              height: 200, // Set the fixed height as needed
                              child: SingleChildScrollView(
                                child: Column(
                                    children: generateSessionCards(setState)
                                ),
                              )
                          ),
                        ],
                      );
                    }
                  ),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        if(scheduleExpander.expanded){
                          int trainerId = Globals.trainers[Random().nextInt(Globals.trainers.length)].toTableColumnMap()['accounts']!['accountid'];
                          await Globals.database.query("INSERT INTO sessions (trainerid, memberid, sessiondetails, sessiontype, starttime, endtime, date) VALUES ('$trainerId', '${Globals.currentAccount['accounts']['accountid']}', '${sessionDetailController.text}', '$sessionType' , '$startTimeText', '$endTimeText', '$date')");
                        }
                        Navigator.pop(context);
                      },
                      child: Text('Confirm'),
                    ),
                  ],
                );
              },
            );
          },
          focusedDay: DateTime.now(),
        )
      ],
    );
  }
}
