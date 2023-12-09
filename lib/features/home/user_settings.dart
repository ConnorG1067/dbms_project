import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

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

  String generalError = "";

  Future<void> updateUserInformationInDb(String field, dynamic value) async {
    Map<String, dynamic> currentAccountMap = Globals.currentAccount['accounts'];
    int accountId = currentAccountMap['accountid'];
    await Globals.database.query("Update Users SET $field = $value WHERE accountid = $accountId");
  }

  Widget updateStringFieldDbWidget(String title, String heading, String subHeading, TextEditingController controller, String dbFieldName) {
    // NEED TO GET DATA ASYNCHRONOUSLY FROM USERS TABLE TO FILL IN THE TEXTEDIT PLACEHOLDER VALUES
    return SizedBox(
      width: 200,
      child: fluent.InfoLabel(
        labelStyle: TextStyle(color: Colors.black),
        label: title,
        child: fluent.TextBox(
          placeholder: Globals.currentAccount['accounts'][dbFieldName],
          expands: false,
          onTap: ()  async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(heading),
                  content: TextField(
                    controller: editAgeController,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            updateStringFieldDbWidget("Age", "Change Age", "New Age", editAgeController, "age"),
            const SizedBox(height: 20),
            updateStringFieldDbWidget("First Name", "Change First Name", "New Name", editFirstNameController, "firstname"),
            const SizedBox(height: 20),
            updateStringFieldDbWidget("Last Name", "Change Last Name", "New Name", editLastNameController, "lastname"),
            const SizedBox(height: 20),
            updateStringFieldDbWidget("Weight", "Change Weight", "New Name", editWeightController, "weight"),
            const SizedBox(height: 20),
            updateStringFieldDbWidget("Feet", "Change Height (feet)", "New Feet", editFeetController, "feet"),
            const SizedBox(height: 20),
            updateStringFieldDbWidget("Inches", "Change Height (inches)", "New Inches", editInchesController, "inches"),
            const SizedBox(height: 20),
            updateStringFieldDbWidget("Sex", "Change Sex", "New Sex", editSexController, "sex"),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
