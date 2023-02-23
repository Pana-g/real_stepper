import 'package:flutter/material.dart';
import 'package:real_stepper/real_stepper.dart';

class StepWrapper extends StatefulWidget {
  final StepStatus status;
  final int index;
  final Widget child;
  final Border? activeBorder;
  final Color activeBorderColor;
  final EdgeInsets stepContainerWrapperPadding;
  const StepWrapper(
      {super.key,
      required this.status,
      required this.index,
      required this.child,
      required this.activeBorder,
      required this.activeBorderColor,
      required this.stepContainerWrapperPadding});

  @override
  State<StepWrapper> createState() => StepWrapperState();
}

class StepWrapperState extends State<StepWrapper> {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.key,
      decoration: widget.status == StepStatus.active
          ? BoxDecoration(
              border: widget.activeBorder ??
                  Border.all(width: 2, color: widget.activeBorderColor),
              borderRadius: BorderRadius.circular(40))
          : null,
      padding: widget.stepContainerWrapperPadding,
      margin: widget.status == StepStatus.active
          ? widget.stepContainerWrapperPadding
          : null,
      child: widget.child,
    );
  }
}
