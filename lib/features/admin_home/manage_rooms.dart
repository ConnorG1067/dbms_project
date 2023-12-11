import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

import '../../util/globals.dart';

class ManageRooms extends StatefulWidget {
  const ManageRooms({Key? key}) : super(key: key);

  @override
  State<ManageRooms> createState() => _ManageRoomsState();
}

class _ManageRoomsState extends State<ManageRooms> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: () async {
          return await Globals.database.query("SELECT * FROM room");
        }(),
        builder: (BuildContext context, AsyncSnapshot<PostgreSQLResult> snapshot) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> roomMap = snapshot.data![index].toColumnMap();
              return Column(
                children: [
                  Card(
                    child: ListTile(
                      title: Text('Room ID: ${roomMap['roomid']}'),
                      subtitle: Text('Room Type: ${roomMap['roomtype']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          Globals.database.query("DELETE FROM room WHERE roomid=${roomMap['roomid']}");
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  if(index == snapshot.data!.length-1) Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Globals.database.query("INSERT INTO room (roomtype) VALUES ('Yoga Room')");
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue, // Set the background color to blue
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add), // Add '+' icon
                            SizedBox(width: 8.0),
                            Text("Add new yoga room"),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Globals.database.query("INSERT INTO room (roomtype) VALUES ('Weight Lifting Room')");
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue, // Set the background color to blue
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add), // Add '+' icon
                            SizedBox(width: 8.0),
                            Text("Add new strength room"),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Globals.database.query("INSERT INTO room (roomtype) VALUES ('Cardio Room')");
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue, // Set the background color to blue
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add), // Add '+' icon
                            SizedBox(width: 8.0),
                            Text("Add new cardio room"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          );
        }
    );
  }
}
