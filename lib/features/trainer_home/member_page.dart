import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

import '../../util/globals.dart';

class MemberProfilePage extends StatefulWidget {
  const MemberProfilePage({Key? key}) : super(key: key);

  @override
  State<MemberProfilePage> createState() => _MemberProfilePageState();
}

class _MemberProfilePageState extends State<MemberProfilePage> {

  ExpandableController expandableController = ExpandableController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: () async {
          return await Globals.database.query("SELECT * FROM accounts WHERE account_type='member'");
        }(),
        builder: (context, AsyncSnapshot<PostgreSQLResult> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurpleAccent,
              ),
            );
          }else{
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var user = snapshot.data![index];
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
                          leading: CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text('${user[2]} ${user[3]}'),
                        ),
                      ),
                      expanded: FutureBuilder(
                          future: () async {
                            return await Globals.database.query("SELECT * FROM Users WHERE accountid=${user[0]}");
                          }(),
                          builder: (BuildContext context, AsyncSnapshot<PostgreSQLResult> snapshot) {

                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.deepPurpleAccent,
                                ),
                              );
                            }else{
                              Map<String,dynamic> userInfoMap = snapshot.data!.first.toColumnMap();
                              return Card(
                                elevation: 4,
                                margin: EdgeInsets.all(16),
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Name: ${userInfoMap['firstname']} ${userInfoMap['lastname']}',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 8),
                                      Text('Weight: ${userInfoMap['weight']} lbs'),
                                      Text('Age: ${userInfoMap['age']}'),
                                      Text('Height: ${userInfoMap['feet']} feet ${userInfoMap['inches']} inches'),
                                      Text('Sex: ${userInfoMap['sex']}'),
                                    ],
                                  ),
                                ),
                              );
                            }
                          }
                      ),
                      collapsed: Container(),
                    ),
                  ),
                );
              },
            );
          }
        }
    );
  }
}
