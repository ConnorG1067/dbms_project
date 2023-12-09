import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:postgres/postgres.dart';

import '../../util/globals.dart';

class EquipmentMaintenancePage extends StatefulWidget {
  const EquipmentMaintenancePage({Key? key}) : super(key: key);

  @override
  State<EquipmentMaintenancePage> createState() => _EquipmentMaintenancePageState();
}

class _EquipmentMaintenancePageState extends State<EquipmentMaintenancePage> {
  TextEditingController addStepsController = TextEditingController();
  TextEditingController addHydrationController = TextEditingController();
  TextEditingController addCalorieIntakeController = TextEditingController();
  TextEditingController addWeightController = TextEditingController();
  TextEditingController addSleepHoursController = TextEditingController();
  TextEditingController addActiveMinutesController = TextEditingController();

  String generalError = "";

  Future<void> addEquipmentDb(String steps, String hydration, String calorieIntake, String weight, String sleepHours, String activeMinutes) async {
    Map<String, dynamic> currentAccountMap = Globals.currentAccount['accounts'];
    int accountId = currentAccountMap['accountid'];
    await Globals.database.query("INSERT INTO equipment (purchasedate) VALUES (${DateTime.now()})");
    
  }

  Future<void> addLogDb(String equipmentId, DateTime logDate, String notes) async {
    Map<String, dynamic> currentAccountMap = Globals.currentAccount['accounts'];
    int accountId = currentAccountMap['accountid'];
    await Globals.database.query("INSERT INTO maintenanceLogs (loggedby, equipmentid, logdate, notes) VALUES ($accountId, $logDate, $notes)");
  }

  Future<PostgreSQLResult> getUserEquipmentMaintenances() async {
    Map<String, dynamic> currentAccountMap = Globals.currentAccount['accounts'];
    int accountId = currentAccountMap['accountid'];
    return await Globals.database.query("SELECT * FROM dailylogs WHERE accountid = $accountId");
  }


  Widget updateStringFieldDbWidget(String title, TextEditingController controller, String dbFieldName) {
    return SizedBox(
      width: 200,
      child: fluent.InfoLabel(
        labelStyle: const TextStyle(color: Colors.black),
        label: title,
        child: fluent.TextBox(
          controller: controller,
          placeholder: Globals.currentAccount['accounts'][dbFieldName],
          expands: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            updateStringFieldDbWidget("Steps", addStepsController, "steps"),
            const SizedBox(height: 20),
            updateStringFieldDbWidget("Hydration", addHydrationController, "hydration"),
            const SizedBox(height: 20),
            updateStringFieldDbWidget("Calorie Intake", addCalorieIntakeController, "calorieintake"),
            const SizedBox(height: 20),
            updateStringFieldDbWidget("Weight", addWeightController, "weight"),
            const SizedBox(height: 20),
            updateStringFieldDbWidget("Sleep Hours", addSleepHoursController, "sleephours"),
            const SizedBox(height: 20),
            updateStringFieldDbWidget("Active Minutes", addActiveMinutesController, "activemins"),
            const SizedBox(height: 20),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                //addLogDb();
              },
            ),

            const SizedBox(height: 15),
            const Text('User Logs:'),

            SizedBox(
              height: 200,
              child: FutureBuilder(
                future: getUserEquipmentMaintenances(),
                initialData: "User Logs",
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.deepPurpleAccent,
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'An ${snapshot.error} occurred',
                          style: const TextStyle(fontSize: 18, color: Colors.red),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      final data = (snapshot.data) as List;
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Text('Steps: ${data[index][1]}'),
                              const SizedBox(width: 5),
                              Text('Hydration: ${data[index][2]}'),
                              const SizedBox(width: 5),
                              Text('Calorie Intake: ${data[index][3]}'),
                              const SizedBox(width: 5),
                              Text('Weight: ${data[index][4]}'),
                              const SizedBox(width: 5),
                              Text('Sleep Hours: ${data[index][5]}'),
                              const SizedBox(width: 5),
                              Text('Active Minutes: ${data[index][6]}'),
                            ]
                          );
                        },
                      );
                    }
                  }

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}
