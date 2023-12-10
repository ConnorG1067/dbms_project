import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:postgres/postgres.dart';

import '../../util/globals.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({Key? key}) : super(key: key);

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  bool isMale = true;
  TextEditingController editWeightController = TextEditingController();
  TextEditingController editFeetController = TextEditingController();
  TextEditingController editInchesController = TextEditingController();
  TextEditingController editAgeController = TextEditingController();
  TextEditingController editFirstNameController = TextEditingController();
  TextEditingController editLastNameController = TextEditingController();
  TextEditingController editSexController = TextEditingController();

  TextEditingController editStepsController = TextEditingController();
  TextEditingController editHydrationController = TextEditingController();
  TextEditingController editCalorieIntakeController = TextEditingController();
  TextEditingController editWeightGoalController = TextEditingController();
  TextEditingController editSleepHoursController = TextEditingController();
  TextEditingController editActiveMinutesController = TextEditingController();
  String generalError = "";

  Future<void> updateUserInformationInDb(String field, dynamic value) async {
    Map<String, dynamic> currentAccountMap = Globals.currentAccount['accounts'];
    int accountId = currentAccountMap['accountid'];
    await Globals.database.query("UPDATE Users SET $field='$value' WHERE accountid=$accountId");
  }

  Widget updateUserInformation(String title, String heading, String subHeading, TextEditingController controller, String dbFieldName, String placeholder) {
    // NEED TO GET DATA ASYNCHRONOUSLY FROM USERS TABLE TO FILL IN THE TEXTEDIT PLACEHOLDER VALUES
    return SizedBox(
      width: 200,
      child: fluent.InfoLabel(
        labelStyle: TextStyle(color: Colors.black),
        label: title,
        child: fluent.TextBox(
          placeholder: placeholder,
          expands: false,
          onTap: ()  async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(heading),
                  content: TextField(
                    controller: controller,
                    decoration: InputDecoration(hintText: subHeading),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Submit'),
                      onPressed: () {
                        Globals.database.query("UPDATE goals SET $dbFieldName=${controller.text} WHERE accountid=${Globals.currentAccount['accounts']!['accountid']}");
                        Navigator.of(context).pop();
                        setState(() {});
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget updateUserGoals(String title, String heading, String subHeading, TextEditingController controller, String dbFieldName, String placeholder) {
    // NEED TO GET DATA ASYNCHRONOUSLY FROM USERS TABLE TO FILL IN THE TEXTEDIT PLACEHOLDER VALUES
    return SizedBox(
      width: 200,
      child: fluent.InfoLabel(
        labelStyle: TextStyle(color: Colors.black),
        label: title,
        child: fluent.TextBox(
          placeholder: placeholder,
          expands: false,
          onTap: ()  async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(heading),
                  content: TextField(
                    controller: controller,
                    decoration: InputDecoration(hintText: subHeading),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Submit'),
                      onPressed: () {
                        updateUserInformationInDb(dbFieldName, controller.text);
                        Navigator.of(context).pop();
                        setState(() {});
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<Map<String, PostgreSQLResult>> fetchData() async {
    return {
      'userInfo': await Globals.database.query(
          "SELECT * FROM users WHERE accountid=${Globals
              .currentAccount['accounts']!['accountid']}"),
      'userGoals': await Globals.database.query(
          "SELECT * FROM goals WHERE accountid=${Globals
              .currentAccount['accounts']!['accountid']}"),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: fetchData(),
          builder: (BuildContext context, AsyncSnapshot<Map<String, PostgreSQLResult>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurpleAccent,
              ),
            );
          }else{
            Map<String, dynamic> userInfoMap = snapshot.data!['userInfo']!.first.toColumnMap();
            Map<String, dynamic> userGoalMap = snapshot.data!['userGoals']!.first.toColumnMap();
            return Padding(
              padding: const EdgeInsets.all(50),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text("User Goals"),
                      SizedBox(height: 15),
                      updateUserGoals("Age", "Change Age", "New Age", editAgeController, "age", userInfoMap['age'].toString()),
                      const SizedBox(height: 20),
                      updateUserGoals("First Name", "Change First Name", "New Name", editFirstNameController, "firstname", userInfoMap['firstname']),
                      const SizedBox(height: 20),
                      updateUserGoals("Last Name", "Change Last Name", "New Name", editLastNameController, "lastname", userInfoMap['lastname']),
                      const SizedBox(height: 20),
                      updateUserGoals("Weight", "Change Weight", "New Name", editWeightController, "weight", userInfoMap['weight'].toString()),
                      const SizedBox(height: 20),
                      updateUserGoals("Feet", "Change Height (feet)", "New Feet", editFeetController, "feet", userInfoMap['feet'].toString()),
                      const SizedBox(height: 20),
                      updateUserGoals("Inches", "Change Height (inches)", "New Inches", editInchesController, "inches", userInfoMap['inches'].toString()),
                      const SizedBox(height: 20),
                      updateUserGoals("Sex", "Change Sex", "New Sex", editSexController, "sex", userInfoMap['sex']),
                      const SizedBox(height: 20),
                    ],
                  ),
                  SizedBox(width: 25),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("User Goals"),
                      SizedBox(height: 15),
                      updateUserInformation("Steps", "Change Steps Goal", "New Steps Goal", editStepsController, 'steps', userGoalMap['steps'].toString()),
                      const SizedBox(height: 20),
                      updateUserInformation("Hydration", "Change Hydration Goal", "New Hydration Goal", editHydrationController, 'hydration', userGoalMap['hydration'].toString()),
                      const SizedBox(height: 20),
                      updateUserInformation("Calorie Intake", "Change Calorie Intake", "New Calorie Intake", editCalorieIntakeController, 'calorieintake', userGoalMap['calorieintake'].toString()),
                      const SizedBox(height: 20),
                      updateUserInformation("Weight", "Change Weight", "New Weight", editWeightGoalController, 'weight', userGoalMap['weight'].toString()),
                      const SizedBox(height: 20),
                      updateUserInformation("Sleep Hours", "Change Sleep Hours", "New Sleep Hours", editSleepHoursController, 'sleephours', userGoalMap['sleephours'].toString()),
                      const SizedBox(height: 20),
                      updateUserInformation("Active Minutes", "Change Active Minutes", "New Active Minutes", editActiveMinutesController, 'activemins', userGoalMap['activemins'].toString()),
                    ],
                  ),
                ],
              ),
            );
          }
        }
      ),
    );
  }
}
