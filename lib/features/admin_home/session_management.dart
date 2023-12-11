import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import '../../util/globals.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting

class SessionManagement extends StatefulWidget {
  const SessionManagement({Key? key}) : super(key: key);

  @override
  State<SessionManagement> createState() => _SessionManagementState();
}

class _SessionManagementState extends State<SessionManagement> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: () async {
        return await Globals.database.query("SELECT * FROM sessions");
      }(),
      builder: (BuildContext context, AsyncSnapshot<PostgreSQLResult> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Placeholder for when data is loading
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        List<PostgreSQLResultRow> sessions = snapshot.data!;

        return ListView.builder(
          itemCount: sessions.length,
          itemBuilder: (context, index) {
            PostgreSQLResultRow session = sessions[index];

            return Card(
              elevation: 4.0,
              margin: EdgeInsets.all(8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ExpandablePanel(
                header: ListTile(
                  title: Text(
                    'Session Details',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Session Type: ${session.toColumnMap()['sessiontype']}',
                    style: TextStyle(fontSize: 12.0),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await Globals.database.query(
                          "DELETE FROM sessions WHERE date=TO_DATE('${DateFormat(
                              'yyyy-MM-dd').format(
                              session.toColumnMap()['date'])}', 'YYYY-MM-DD') AND starttime='${session.toColumnMap()['starttime']}' AND endtime='${session.toColumnMap()['endtime']}' AND memberid='${session.toColumnMap()['memberid']}' AND trainerid='${session.toColumnMap()['trainerid']}'");
                      setState(() {});
                    },
                  ),
                ),
                collapsed: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Session Type: ${session.toColumnMap()['sessiontype']}',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      Text(
                        'Date: ${session.toColumnMap()['date']}',
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
                expanded: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Trainer ID: ${session.toColumnMap()['trainerid']}'),
                      Text('Member ID: ${session.toColumnMap()['memberid']}'),
                      Text('Session Details: ${session.toColumnMap()['sessiondetails']}'),
                      Text('Start Time: ${session.toColumnMap()['starttime']}'),
                      Text('End Time: ${session.toColumnMap()['endtime']}'),
                      Text('Date: ${session.toColumnMap()['date']}'),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
