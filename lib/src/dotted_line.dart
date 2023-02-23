import 'package:flutter/material.dart';

double dotSize = 3;

class _DrawDottedhorizontalline extends StatelessWidget {
  final Color color;
  final double length;
  final double thickness;
  final Axis direction;
  const _DrawDottedhorizontalline({
    Key? key,
    required this.color,
    required this.length,
    required this.thickness,
    required this.direction,
  }) : super(key: key);

  double getLengthChild(int pos) {
    if (pos % 2 == 0) {
      return dotSize;
    }
    return dotSize;
  }

  Color? getColorChild(int pos) {
    if (pos % 2 == 0) {
      return color;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: direction,
      children: List.generate(
          (length / dotSize).toInt(),
          (index) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: getColorChild(index),
              ),
              width: getLengthChild(index),
              height: getLengthChild(index))),
    );
  }
}

class DottedLine extends StatelessWidget {
  final Color color;
  final double length;
  final Axis direction;
  final double thickness;
  const DottedLine({
    Key? key,
    required this.color,
    required this.length,
    required this.direction,
    required this.thickness,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: _DrawDottedhorizontalline(
      color: color,
      length: length,
      direction: direction,
      thickness: thickness,
    ));
  }
}
