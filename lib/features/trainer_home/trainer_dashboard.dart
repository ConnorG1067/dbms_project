import 'dart:math';

import 'package:dbms_project/Widgets/dashboard_widgets.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting

import '../../util/globals.dart';

class TrainerDashboard extends StatefulWidget {
  const TrainerDashboard({Key? key}) : super(key: key);

  @override
  State<TrainerDashboard> createState() => _TrainerDashboardState();
}

class _TrainerDashboardState extends State<TrainerDashboard> {


  @override
  Widget build(BuildContext context) {
      return ListView(
        children: [
          Center(
            child: TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              eventLoader: (day) {
                return List.from(Globals.sessions.where((element) =>
                    element.toString().contains(
                        DateFormat('yyyy-MM-dd').format(day))));
              },
              onDayLongPressed: (date, events) async {
                List<dynamic> currentSessions = List.from(
                    await Globals.database.query(
                        "SELECT * FROM sessions WHERE date=TO_DATE('${DateFormat(
                            'yyyy-MM-dd').format(
                            date)}', 'YYYY-MM-DD') AND trainerid='${Globals
                            .currentAccount['accounts']['accountid']}'"));

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    ExpandableController scheduleExpander = ExpandableController();
                    ExpandableController cancelExpander = ExpandableController();
                    String sessionType = 'Cardio'; // Default session type
                    String startTimeText = "12:00PM";
                    String endTimeText = "1:00PM";
                    TextEditingController sessionDetailController = TextEditingController();

                    List<Widget> generateSessionCards(dialogState) {
                      return List.generate(currentSessions.length, (index) {
                        Map<String, dynamic> cardInfo = currentSessions[index]
                            .toTableColumnMap()['sessions']!;
                        return Row(
                          children: [
                            Card(
                              margin: const EdgeInsets.all(16),
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Text(
                                          'Session Details:',
                                          style: TextStyle(fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(cardInfo['sessiondetails']),
                                      ],
                                    ),
                                    SizedBox(width: 16),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Text(
                                          'Session Type:',
                                          style: TextStyle(fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(cardInfo['sessiontype']),
                                      ],
                                    ),
                                    SizedBox(width: 16),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Text(
                                          'Date:',
                                          style: TextStyle(fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(cardInfo['date'].toString()),
                                      ],
                                    ),
                                    SizedBox(width: 16),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Text(
                                          'Start Time:',
                                          style: TextStyle(fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(cardInfo['starttime']),
                                      ],
                                    ),
                                    SizedBox(width: 16),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Text(
                                          'End Time:',
                                          style: TextStyle(fontSize: 16,
                                              fontWeight: FontWeight.bold),
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
                                await Globals.database.query(
                                    "DELETE FROM sessions WHERE date=TO_DATE('${DateFormat(
                                        'yyyy-MM-dd').format(
                                        date)}', 'YYYY-MM-DD') AND starttime='${cardInfo['starttime']}' AND endtime='${cardInfo['endtime']}' AND trainerid='${Globals
                                        .currentAccount['accounts']['accountid']}' AND memberid='${cardInfo['memberid']}'");
                                dialogState(() {
                                  currentSessions.removeAt(index);
                                });

                                setState(() => Globals.sessions.removeWhere((
                                    element) =>
                                element[0] == cardInfo['trainerid'] &&
                                    element[1] == cardInfo['memberid'] &&
                                    element[2] ==
                                        cardInfo['sessiondetails'] &&
                                    element[3] == cardInfo['sessiontype'] &&
                                    element[4] == cardInfo['starttime'] &&
                                    element[5] == cardInfo['endtime'] &&
                                    element[6] == cardInfo['date']));
                              },
                              child: Text("Cancel Session"),
                            )
                          ],
                        );
                      }
                      );
                    }


                    return AlertDialog(
                      title: Text('Schedule or cancel a session for ${date
                          .year}-${date.month}-${date.day}'),
                      content: StatefulBuilder(
                          builder: (BuildContext context,
                              StateSetter setStateDialog) {
                            return Column(
                              children: [
                                SizedBox(height: 20),
                                Padding(padding: EdgeInsets.only(left: 16.0),
                                    child: Align(child: Text(
                                        "Sessions for date ${DateFormat(
                                            'yyyy-MM-dd').format(date)}",
                                        style: TextStyle(fontSize: 16)),
                                        alignment: Alignment.centerLeft)),
                                Container(
                                    height: 200,
                                    // Set the fixed height as needed
                                    child: SingleChildScrollView(
                                      child: Column(
                                          children: generateSessionCards(
                                              setStateDialog)
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
                            if (scheduleExpander.expanded) {
                              int trainerId = Globals.trainers[Random()
                                  .nextInt(Globals.trainers.length)]
                                  .toTableColumnMap()['accounts']!['accountid'];
                              await Globals.database.query(
                                  "INSERT INTO sessions (trainerid, memberid, sessiondetails, sessiontype, starttime, endtime, date) VALUES ('$trainerId', '${Globals
                                      .currentAccount['accounts']['accountid']}', '${sessionDetailController
                                      .text}', '$sessionType' , '$startTimeText', '$endTimeText', '$date')");
                              setState(() => Globals.sessions.add([
                                trainerId,
                                Globals
                                    .currentAccount['accounts']['accountid'],
                                sessionDetailController.text,
                                sessionType,
                                startTimeText,
                                endTimeText,
                                date
                              ]));
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
        ),
        FutureBuilder(
          future: () async {
            return await Globals.database.query("SELECT * FROM sessions WHERE trainerid=${Globals.currentAccount['accounts']['accountid']}");
          }(),
          builder: (context, AsyncSnapshot<PostgreSQLResult> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.deepPurpleAccent,
                ),
              );
            }else{
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Align(
                      child: Text("Upcoming Sessions"),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  Column(
                      children:
                      List.generate(snapshot.data!.length, (index) {
                        Map<String,dynamic> currentSessionMap = snapshot.data![index].toColumnMap();
                        return Card(
                          margin: const EdgeInsets.all(16),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start,
                                  children: [
                                    Text(
                                      'Session Details:',
                                      style: TextStyle(fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(currentSessionMap['sessiondetails']),
                                  ],
                                ),
                                SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start,
                                  children: [
                                    Text(
                                      'Session Type:',
                                      style: TextStyle(fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(currentSessionMap['sessiontype']),
                                  ],
                                ),
                                SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start,
                                  children: [
                                    Text(
                                      'Date:',
                                      style: TextStyle(fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(currentSessionMap['date'].toString()),
                                  ],
                                ),
                                SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start,
                                  children: [
                                    Text(
                                      'Start Time:',
                                      style: TextStyle(fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(currentSessionMap['starttime']),
                                  ],
                                ),
                                SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start,
                                  children: [
                                    Text(
                                      'End Time:',
                                      style: TextStyle(fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(currentSessionMap['endtime']),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    )
                  ),
                ],
              );
            }
          }
        )
      ]
    );
  }
}
