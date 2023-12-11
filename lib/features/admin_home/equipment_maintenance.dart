import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:postgres/postgres.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              String name = "";
              DateTime selectedDate = DateTime.now();
              return AlertDialog(
                title: Text('Equipment Name'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Enter Name'),
                      onChanged: (value) {
                        name = value;
                      },
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Text('Selected Date: ${selectedDate.toLocal()}'),
                        SizedBox(width: 8.0),
                        ElevatedButton(
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null && pickedDate != selectedDate) {
                              selectedDate = pickedDate;
                              // Update the displayed date in the dialog
                              Navigator.of(context).pop();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Equipment Name'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          decoration: InputDecoration(labelText: 'Enter Name'),
                                          onChanged: (value) {
                                            name = value;
                                          },
                                        ),
                                        SizedBox(height: 16.0),
                                        Row(
                                          children: [
                                            Text('Selected Date: ${selectedDate.toLocal()}'),
                                            SizedBox(width: 8.0),
                                            ElevatedButton(
                                              onPressed: () async {
                                                DateTime? pickedDate = await showDatePicker(
                                                  context: context,
                                                  initialDate: selectedDate,
                                                  firstDate: DateTime(2000),
                                                  lastDate: DateTime(2101),
                                                );
                                                if (pickedDate != null && pickedDate != selectedDate) {
                                                  selectedDate = pickedDate;
                                                  // Update the displayed date in the dialog
                                                  Navigator.of(context).pop();
                                                }
                                              },
                                              child: Text('Pick Date'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Close the dialog
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Perform actions with user input (name and selectedDate)
                                          print("INSERT INTO equipment (name, purchasedate) VALUES ('$name, TO_DATE('${DateFormat('yyyy-MM-dd').format(selectedDate)}', 'YYYY-MM-DD'))");
                                          Globals.database.query("INSERT INTO equipment (name, purchasedate) VALUES ('$name', TO_DATE('${DateFormat('yyyy-MM-dd').format(selectedDate)}', 'YYYY-MM-DD'))");
                                          setState(() {});
                                          Navigator.of(context).pop(); // Close the dialog
                                        },
                                        child: Text('Confirm'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: Text('Pick Date'),
                        ),
                      ],
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Perform actions with user input (name and selectedDate)
                      print('Name: $name, Date: $selectedDate');
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text('Confirm'),
                  ),
                ],
              );
            },
          );

          // Globals.database.query("INSERT")
        },
        backgroundColor: Colors.blue, // Set the background color
        child: Icon(Icons.add),
      ),
      body: FutureBuilder(
          future: () async {
            return await Globals.database.query("SELECT * FROM equipment");
          }(),
          builder: (BuildContext context, AsyncSnapshot<PostgreSQLResult> snapshot) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> roomMap = snapshot.data![index].toColumnMap();
                return Card(
                  child: ListTile(
                    title: Text('Equipment Name: ${roomMap['name']}'),
                    subtitle: Text('Equipment ID: ${roomMap['equipmentid']} \t Purchased: ${DateFormat('yyyy-MM-dd').format(roomMap['purchasedate'])}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        Globals.database.query("DELETE FROM equipment WHERE equipmentid=${roomMap['equipmentid']}");
                        setState(() {});
                      },
                    ),
                  ),
                );
              }
          );
        }
      ),
    );
  }
}
