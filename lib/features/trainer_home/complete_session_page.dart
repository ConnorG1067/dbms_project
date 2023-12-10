import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import '../../util/globals.dart';

class CompletedSessionPage extends StatefulWidget {
  const CompletedSessionPage({Key? key}) : super(key: key);

  @override
  State<CompletedSessionPage> createState() => _CompletedSessionPageState();
}

class _CompletedSessionPageState extends State<CompletedSessionPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: () async {
        print("FUCK");
        return await Globals.database.query("SELECT * FROM sessions WHERE date<TO_DATE('${DateFormat('yyyy-MM-dd').format(DateTime.now())}', 'YYYY-MM-DD')");
      }(),
      builder: (context, AsyncSnapshot<PostgreSQLResult> snapshot) {
        return ListView.builder(
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, index) {
            Map<String,dynamic> sessionDetails = snapshot.data![index].toColumnMap();
            ExpandableController expandableController = ExpandableController();

            return ExpandableNotifier(
              controller: expandableController,
              child: Card(
                margin: EdgeInsets.all(8),
                child: ExpandablePanel(
                  header: GestureDetector(
                    onTap: () {
                      expandableController.toggle();
                    },
                    child: ListTile(
                      title: Text('${sessionDetails['starttime']} - ${sessionDetails['endtime']}'),
                    ),
                  ),
                  expanded: Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: FutureBuilder(
                        future: Globals.database.query("SELECT * FROM Users WHERE accountid=${sessionDetails['memberid']}"),
                        builder: (BuildContext context, AsyncSnapshot<PostgreSQLResult> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Text('No user data available.');
                          } else {
                            Map<String, dynamic> userInfoMap = snapshot.data!.first.toColumnMap();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Name: ${userInfoMap['firstname']} ${userInfoMap['lastname']}',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text('Weight: ${userInfoMap['weight']} lbs'),
                                Text('Age: ${userInfoMap['age']}'),
                                Text('Height: ${userInfoMap['feet']} feet ${userInfoMap['inches']} inches'),
                                Text('Sex: ${userInfoMap['sex']}'),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  collapsed: Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${sessionDetails['starttime']} - ${sessionDetails['endtime']}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text('Click to expand for more details'),
                          const SizedBox(height: 8),
                          TextButton(onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                TextEditingController noteController = TextEditingController();
                                return AlertDialog(
                                  title: const Text('Enter Notes'),
                                  content: TextField(
                                    controller: noteController,
                                    maxLines: 10,
                                    decoration: InputDecoration(
                                      hintText: 'Enter Session Notes',
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Globals.database.query("INSERT INTO sessionNote (trainerid, memberid, note, date) VALUES (${sessionDetails['trainerid']}, ${sessionDetails['memberid']}, '${noteController.text}', TO_DATE('${DateFormat('yyyy-MM-dd').format(sessionDetails['date'])}', 'YYYY-MM-DD'))");
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Submit'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Close the dialog without performing any action
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }, child: const Text("Add Notes"))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }
    );
  }
}
