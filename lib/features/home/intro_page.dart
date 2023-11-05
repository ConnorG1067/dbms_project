import 'package:dbms_project/features/home/member_dashboard.dart';
import 'package:flutter/material.dart';

import '../../util/globals.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  bool isMale = true;
  TextEditingController weightController = TextEditingController();
  TextEditingController feetController = TextEditingController();
  TextEditingController inchesController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  String generalError = "";

  Future<void> logUserInformationInDb(double weight, int feet, int inches, int age, bool male) async {
    Map<String, dynamic> currentAccountMap = Globals.currentAccount.first.toTableColumnMap()['accounts']!;
    int accountId = currentAccountMap['accountid'];
    String firstName = currentAccountMap['firstname'];
    String lastName = currentAccountMap['lastname'];

    await Globals.database.query("INSERT INTO Users (accountId, firstName, lastName, weight, age, feet, inches, sex) VALUES ($accountId, '$firstName', '$lastName', $weight, $age, $feet, $inches, '${(male) ? "male" : "female"}')");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              child: TextField(
                controller: weightController,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.red),
                  label: Text((generalError.isNotEmpty) ? generalError : ""),
                  hintText: "Weight"
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  child: TextField(
                    controller: feetController,
                    decoration: InputDecoration(
                        hintText: "Feet"
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  child: TextField(
                    controller: inchesController,
                    decoration: InputDecoration(
                        hintText: "Inches"
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: 200,
              child: TextField(
                controller: ageController,
                keyboardType: TextInputType.number,

                decoration: InputDecoration(

                  hintText: "Age"
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 95,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: (isMale) ? MaterialStateProperty.all(Colors.blue) : MaterialStateProperty.all(Colors.white),
                        foregroundColor: (isMale) ? MaterialStateProperty.all(Colors.white) : MaterialStateProperty.all(Colors.black)
                    ),
                    child: Text('Male'),
                    onPressed: () {
                      setState(() => isMale = true);
                    },
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: 95,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: (!isMale) ? MaterialStateProperty.all(Colors.blue) : MaterialStateProperty.all(Colors.white),
                      foregroundColor: (!isMale) ? MaterialStateProperty.all(Colors.white) : MaterialStateProperty.all(Colors.black)
                    ),
                    child: Text('Female'),
                    onPressed: () {
                      setState(() => isMale = false);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              width: 200,
              child: ElevatedButton(
                  onPressed: () async {
                    if(weightController.text.isEmpty || feetController.text.isEmpty || inchesController.text.isEmpty || ageController.text.isEmpty){
                      setState(() => generalError = "All fields are required");
                    }else{
                      await logUserInformationInDb(double.parse(weightController.text), int.parse(feetController.text), int.parse(inchesController.text), int.parse(ageController.text), isMale).then(
                        (_) => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MemberDashboard()))
                      );
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                  ),
                  child: const Text("Continue")
              ),
            )
          ],
        ),
      ),
    );
  }
}
