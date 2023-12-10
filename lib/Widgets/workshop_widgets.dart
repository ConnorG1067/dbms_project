import 'package:flutter/material.dart';

class WorkshopWidgets{

  static Widget buildImageCard({
    required String imageUrl,
    required String buttonText,
    required VoidCallback onButtonPressed,
  }) {
    return Card(
      elevation: 4, // Adjust elevation for a shadow effect
      margin: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image at the top
          Image.network(
            imageUrl,
            width: 200, // Adjust the height as needed
          ),
          // Button below the image
          Container(
            width: 200,
            child: TextButton(
              onPressed: onButtonPressed,
              child: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }
}