import 'package:dbms_project/Widgets/workshop_widgets.dart';
import 'package:flutter/material.dart';

class WorkShops extends StatefulWidget {
  const WorkShops({Key? key}) : super(key: key);

  @override
  State<WorkShops> createState() => _WorkShopsState();
}

class _WorkShopsState extends State<WorkShops> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WorkshopWidgets.buildImageCard(imageUrl: "https://hips.hearstapps.com/hmg-prod/images/burning-calories-and-strengthening-her-core-with-a-royalty-free-image-1579042741.jpg?crop=0.668xw:1.00xh;0.0136xw,0&resize=1200:*", buttonText: "Register For Strength", onButtonPressed: () {}),
          WorkshopWidgets.buildImageCard(imageUrl: "https://hips.hearstapps.com/hmg-prod/images/burning-calories-and-strengthening-her-core-with-a-royalty-free-image-1579042741.jpg?crop=0.668xw:1.00xh;0.0136xw,0&resize=1200:*", buttonText: "Register For Cardio", onButtonPressed: () {}),
          WorkshopWidgets.buildImageCard(imageUrl: "https://hips.hearstapps.com/hmg-prod/images/burning-calories-and-strengthening-her-core-with-a-royalty-free-image-1579042741.jpg?crop=0.668xw:1.00xh;0.0136xw,0&resize=1200:*", buttonText: "Register For Yoga", onButtonPressed: () {})
        ],
      ),
    );
  }
}
