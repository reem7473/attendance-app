import 'package:flutter/material.dart';

// class CircularChart extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 100,
//       width: 100,
//       child: Center(
//         child: Text('نسبة الحضور'),
//       ), // Placeholder for the circular chart
//     );
//   }
// }

class CircularChart extends StatelessWidget {
  final double radius;
  final double lineWidth;
  final double percent;
  final Widget center;
  final Color progressColor;

  const CircularChart({
    required this.radius,
    required this.lineWidth,
    required this.percent,
    required this.center,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: radius,
          height: radius,
          child: CircularProgressIndicator(
            strokeWidth: lineWidth,
            value: percent,
            color: progressColor,
            backgroundColor: Colors.grey.shade200,
          ),
        ),
        center,
      ],
    );
  }
}