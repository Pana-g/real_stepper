import 'package:flutter/material.dart';

import '../real_stepper.dart';

class RealStepperController {
  late RealStepperState realStepperState;

  void setParent(RealStepperState realStepperState) {
    this.realStepperState = realStepperState;
  }

  void animateToStart({Duration? duration, Curve? curve}) {
    realStepperState.animateToStart();
  }

  void animateToEnd({Duration? duration, Curve? curve}) {
    realStepperState.animateToEnd();
  }

  void animateToIndex(int index, {Duration? duration, Curve? curve}) {
    realStepperState.animateToIndex(index);
  }

  void animateNext() {
    realStepperState.animateToNext();
  }

  void animatePrevious() {
    realStepperState.animateToPrevious();
  }

  StepStatus? getStepStatus(int index) {
    return realStepperState.getStepStatusFromIndex(index);
  }
}
