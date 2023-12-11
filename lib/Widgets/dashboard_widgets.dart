import "package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart";
import "package:flutter/material.dart";

class DashboardWidgets{
  static Widget dashboardCard(double currentCount, double totalCount, String metric, String suffix) {
    final ValueNotifier<double> valueNotifier = ValueNotifier(0);

    return Card(
      elevation: 5, // Adds a shadow to the card
      margin: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: DashedCircularProgressBar.square(
            valueNotifier: valueNotifier,
            progress: currentCount,
            maxProgress: totalCount,
            startAngle: 225,
            sweepAngle: 270,
            foregroundColor: Colors.green,
            backgroundColor: const Color(0xffeeeeee),
            foregroundStrokeWidth: 15,
            backgroundStrokeWidth: 15,
            animation: true,
            seekSize: 6,
            seekColor: const Color(0xffeeeeee),
            dimensions: 100,
            child: Center(
              child: ValueListenableBuilder(
                  valueListenable: valueNotifier,
                  builder: (_, double value, __) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${value.toInt()}/$totalCount $suffix',
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 20
                        ),
                      ),
                      Text(
                        metric,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 16
                        ),
                      ),
                    ],
                  )
              ),
            ),
          ),
      ),
    );
  }
}