import 'dart:math';

import 'package:dbms_project/Widgets/workshop_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../util/globals.dart'; // Import the intl package for date formatting

class WorkShops extends StatefulWidget {
  const WorkShops({Key? key}) : super(key: key);

  @override
  State<WorkShops> createState() => _WorkShopsState();
}

class _WorkShopsState extends State<WorkShops> {

  Future<void> showDatePickerDialog(String trainingType, BuildContext context) async {
    DateTime selectedDate = DateTime.now();

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime
          .now()
          .year + 1),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Successfully registered'),
            content: Row(
              children: [
                Icon(Icons.check, color: Colors.green),
                SizedBox(width: 16),
                Text("You have successfully registered for ${trainingType} on ${DateFormat('yyyy-MM-dd').format(pickedDate)}" ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  String dbTable = (trainingType == "Yoga Workshop") ? "yogaworkshop" : (trainingType == "Strength Workshop") ? "strengthworkshop" : "cardioworkshop";
                  Globals.database.query("INSERT INTO $dbTable (trainerid, memberid, date) VALUES (${Globals.trainers[Random().nextInt(Globals.trainers.length)].toColumnMap()['accountid']}, ${Globals.currentAccount['accounts']!['accountid']}, TO_DATE('${DateFormat('yyyy-MM-dd').format(pickedDate)}', 'YYYY-MM-DD'))");
                  Navigator.of(context).pop();
                },
                child: Text('Confirm'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WorkshopWidgets.buildImageCard(imageUrl: "https://hips.hearstapps.com/hmg-prod/images/burning-calories-and-strengthening-her-core-with-a-royalty-free-image-1579042741.jpg?crop=0.668xw:1.00xh;0.0136xw,0&resize=1200:*", buttonText: "Register For Strength", onButtonPressed: () {showDatePickerDialog("Strength Workshop", context);}),
          WorkshopWidgets.buildImageCard(imageUrl: "https://www.mensjournal.com/.image/c_limit%2Ccs_srgb%2Cq_auto:good%2Cw_700/MTk2MTM3Mjg2ODg2ODI3NTI1/athlete-running-stairs.webp", buttonText: "Register For Cardio", onButtonPressed: () {showDatePickerDialog("Cardio Workshop", context);}),
          WorkshopWidgets.buildImageCard(imageUrl: "https://images.pexels.com/photos/317155/pexels-photo-317155.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1", buttonText: "Register For Yoga", onButtonPressed: () {showDatePickerDialog("Yoga Workshop", context);})
        ],
      ),
    );
  }
}
