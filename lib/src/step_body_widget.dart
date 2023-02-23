import 'package:flutter/material.dart';

import '../real_stepper.dart';

class RealStepBodyWidget extends StatelessWidget {
  final RealStep realStep;
  final bool isActive;
  final Duration contentSwapAnimationDuration;

  const RealStepBodyWidget(
      {super.key,
      required this.isActive,
      required this.realStep,
      required this.contentSwapAnimationDuration});

  @override
  Widget build(BuildContext context) {
    return getAnimatedStep(
        child: realStep.content ?? Container(),
        isVisible: isActive,
        duration: contentSwapAnimationDuration);
  }
}

getAnimatedStep(
    {required Widget child,
    required bool isVisible,
    required Duration duration}) {
  return AnimatedScale(
    duration: duration,
    scale: isVisible ? 1 : 0,
    child: child,
  );
}
