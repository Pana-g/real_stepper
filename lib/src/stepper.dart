import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:real_stepper/real_stepper.dart';
import 'package:real_stepper/src/dotted_line.dart';
import 'package:real_stepper/src/step_body_widget.dart';

class RealStepper extends StatefulWidget {
  final List<RealStep> steps;
  final RealStepperController? controller;
  final int? initialActiveStep;
  final Color? stepColor;
  final Color? disabledStepColor;
  final Color? activeStepColor;
  final Border? activeBorder;
  final Color? errorStepColor;
  final Color? lineColor;
  final Color? completedStepColor;
  final double lineLength;
  final double stepSize;
  final Widget? previousButton;
  final Widget? nextButton;
  final Function(StepStatus stepStatusBeforeReaching, int previousStep,
      int currentStep)? onStepChanged;
  final Color? Function(StepStatus status, int index)? stepColorSelector;
  final Decoration? Function(StepStatus status, int index)?
      stepDecorationSelector;
  final EdgeInsets? padding;
  final EdgeInsets stepContainerWrapperPadding;
  final bool disableAutoScroll;
  final bool disableOnStepTap;
  final bool hideActionButtons;
  final Duration scrollAnimationDuration;
  final Curve scrollAnimation;
  final Duration contentSwapAnimationDuration;

  RealStepper({
    super.key,
    required this.steps,
    this.initialActiveStep,
    this.controller,
    this.stepColor,
    this.contentSwapAnimationDuration = const Duration(milliseconds: 200),
    this.scrollAnimationDuration = const Duration(milliseconds: 400),
    this.scrollAnimation = Curves.bounceOut,
    this.nextButton,
    this.previousButton,
    this.disabledStepColor,
    this.activeStepColor,
    this.disableAutoScroll = false,
    this.disableOnStepTap = false,
    this.hideActionButtons = false,
    this.errorStepColor,
    this.completedStepColor,
    this.stepColorSelector,
    this.stepDecorationSelector,
    this.padding = const EdgeInsets.all(4),
    this.stepContainerWrapperPadding = const EdgeInsets.all(4),
    this.lineColor,
    this.lineLength = 45,
    this.stepSize = 50,
    this.activeBorder,
    this.onStepChanged,
  });

  @override
  State<RealStepper> createState() => RealStepperState(controller);
}

class RealStepperState extends State<RealStepper> {
  ScrollController _scrollController = ScrollController();
  int _activeStep = 0;

  RealStepperState(RealStepperController? stepperController) {
    stepperController?.setParent(this);
  }

  @override
  void initState() {
    _activeStep = widget.initialActiveStep ?? 0;
    super.initState();
  }

  StepStatus? getStepStatusFromIndex(int index) {
    if (widget.steps.length - 1 < index) return null;
    return _getStatus(widget.steps[index], index);
  }

  changeActiveStep(StepStatus status, int index) {
    if (_activeStep == index) {
      return;
    }
    final previousStep = _activeStep;
    setState(() {
      _activeStep = index;
    });
    if (widget.onStepChanged != null) {
      widget.onStepChanged!(status, previousStep, index);
    }
  }

  void animateToStart() {
    if (!_scrollController.hasClients) return;
    animateToIndex(0);
  }

  void animateToEnd() {
    if (!_scrollController.hasClients) return;
    animateToIndex(widget.steps.length - 1);
  }

  void animateToIndex(int index) {
    if (!_scrollController.hasClients) return;
    if (index <= widget.steps.length - 1 && index >= 0) {
      changeActiveStep(_getStatus(widget.steps[index], index), index);
    }
  }

  void animateToNext() {
    if (!_scrollController.hasClients) return;
    if (widget.steps.length - 1 <= _activeStep) return;
    animateToIndex(_activeStep + 1);
  }

  void animateToPrevious() {
    if (!_scrollController.hasClients) return;
    if (_activeStep <= 0) return;
    animateToIndex(_activeStep - 1);
  }

  // calculations fix them for direction
  void scrollToActive() {
    if (!_scrollController.hasClients) return;
    double wrapperPadding = (widget.stepContainerWrapperPadding.left +
        widget.stepContainerWrapperPadding.right);
    double borderWidth = (widget.activeBorder?.left.width ?? 2) +
        (widget.activeBorder?.right.width ?? 2);
    /* double containerPadding = (widget.stepContainerWrapperPadding.left +
            widget.stepContainerWrapperPadding.right) *
        2; */

    double scrollToOffset = 0;
    if (_activeStep > 0) {
      scrollToOffset = _activeStep *
          (widget.lineLength +
              ((widget.stepSize) + wrapperPadding + borderWidth));
    }
    _scrollController.animateTo(scrollToOffset,
        duration: widget.scrollAnimationDuration,
        curve: widget.scrollAnimation);
  }

  StepStatus _getStatus(RealStep realStep, int index) {
    if (realStep.disabled) {
      return StepStatus.disabled;
    }

    if (index <= _activeStep) {
      if (realStep.error != null) {
        return StepStatus.error;
      }
      if (index == _activeStep) {
        return StepStatus.active;
      }
      return StepStatus.completed;
    }

    return StepStatus.none;
  }

  Color _getColor(StepStatus status, int index) {
    if (widget.stepColorSelector != null) {
      Color? colorFromSelector = widget.stepColorSelector!(status, index);
      if (colorFromSelector != null) {
        return colorFromSelector;
      }
    }
    switch (status) {
      case StepStatus.completed:
        return widget.completedStepColor ?? Theme.of(context).primaryColor;
      case StepStatus.none:
        return widget.stepColor ?? Theme.of(context).primaryColor.withAlpha(80);
      case StepStatus.disabled:
        return widget.disabledStepColor ?? Colors.grey.shade500;
      case StepStatus.active:
        return widget.activeStepColor ?? Theme.of(context).primaryColor;
      case StepStatus.error:
        return widget.errorStepColor ?? Theme.of(context).errorColor;
    }
  }

  BoxDecoration _getDecoration(StepStatus status, int index) {
    Color color = _getColor(status, index);
    return BoxDecoration(
        color: color, borderRadius: BorderRadius.circular(100));
  }

  Widget _getWrapper({required StepStatus status, required int index, child}) {
    Color borderColor = _getColor(status, index);
    Border border = widget.activeBorder ??
        Border.all(
            width: 2,
            color: status == StepStatus.active || status == StepStatus.error
                ? borderColor
                : Colors.transparent);

    BoxDecoration decoration =
        BoxDecoration(border: border, borderRadius: BorderRadius.circular(100));
    if (status == StepStatus.active ||
        (status == StepStatus.error && index == _activeStep)) {
      return AnimatedContainer(
        duration: widget.contentSwapAnimationDuration,
        decoration: decoration,
        padding: widget.stepContainerWrapperPadding,
        margin: EdgeInsets.all(4),
        child: child,
      );
    } else {
      return AnimatedContainer(
        duration: widget.contentSwapAnimationDuration,
        decoration: decoration.copyWith(
            border: Border(
          top: BorderSide(width: border.top.width, color: Colors.transparent),
          bottom:
              BorderSide(width: border.bottom.width, color: Colors.transparent),
          left: BorderSide(width: border.left.width, color: Colors.transparent),
          right:
              BorderSide(width: border.right.width, color: Colors.transparent),
        )),
        margin: EdgeInsets.all(4),
        child: child,
      );
    }
  }

  Widget getActiveTitle(RealStep realStep) {
    if (realStep.title != null) {
      return realStep.title ?? Container();
    }
    if (realStep.titleText != null) {
      return Text(
        realStep.titleText ?? '',
        style: Theme.of(context).textTheme.titleLarge,
      );
    }
    return Container();
  }

  Color getBtnEffectsColor() {
    return (widget.stepColor ?? Theme.of(context).primaryColor)
        .withOpacity(0.1);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.disableAutoScroll) {
      scrollToActive();
    }

    return Flex(
      mainAxisSize: MainAxisSize.min,
      direction: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: widget.padding ?? EdgeInsets.zero,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.hideActionButtons
                    ? Container()
                    : AnimatedOpacity(
                        duration: Duration(milliseconds: 200),
                        opacity: _activeStep == 0 ? 0 : 1,
                        child: InkWell(
                          onTap: _activeStep == 0
                              ? null
                              : () {
                                  animateToPrevious();
                                },
                          child: widget.previousButton ??
                              Icon(Icons.arrow_back_ios),
                        ),
                      ),
                Flexible(
                  child: ScrollConfiguration(
                    behavior: MyCustomScrollBehavior(),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      physics: ClampingScrollPhysics(),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: widget.steps
                              .asMap()
                              .entries
                              .map((entry) => Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (entry.key > 0)
                                        DottedLine(
                                          direction: Axis.horizontal,
                                          thickness: 3,
                                          color: widget.lineColor ??
                                              Theme.of(context).primaryColor,
                                          length: widget.lineLength,
                                        ),
                                      InkWell(
                                        hoverColor: getBtnEffectsColor(),
                                        splashColor: getBtnEffectsColor(),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        onTap: widget.disableOnStepTap ||
                                                entry.value.disabled
                                            ? null
                                            : () {
                                                animateToIndex(entry.key);
                                              },
                                        child: _getWrapper(
                                          status: _getStatus(
                                              entry.value, entry.key),
                                          index: entry.key,
                                          child: AnimatedContainer(
                                            duration: widget
                                                .contentSwapAnimationDuration,
                                            decoration: widget
                                                        .stepDecorationSelector !=
                                                    null
                                                ? widget.stepDecorationSelector!(
                                                    _getStatus(
                                                        entry.value, entry.key),
                                                    entry.key)
                                                : _getDecoration(
                                                    _getStatus(
                                                        entry.value, entry.key),
                                                    entry.key),
                                            width: widget.stepSize,
                                            height: widget.stepSize,
                                            child: entry.value.icon,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ))
                              .toList()),
                    ),
                  ),
                ),
                widget.hideActionButtons
                    ? Container()
                    : AnimatedOpacity(
                        duration: Duration(milliseconds: 200),
                        opacity: _activeStep == widget.steps.length - 1 ? 0 : 1,
                        child: InkWell(
                          onTap: _activeStep == widget.steps.length - 1
                              ? null
                              : () {
                                  animateToNext();
                                },
                          child: Icon(Icons.arrow_forward_ios),
                        ),
                      ),
              ],
            ),
          ),
        ),
        if (widget.steps.isNotEmpty)
          getActiveTitle(widget.steps
              .asMap()
              .entries
              .firstWhere((element) => element.key == _activeStep)
              .value),
        Flexible(
          child: Stack(
            alignment: Alignment.topCenter,
            children: widget.steps
                .asMap()
                .entries
                .map((e) => RealStepBodyWidget(
                    contentSwapAnimationDuration:
                        widget.contentSwapAnimationDuration,
                    isActive: _activeStep == e.key,
                    realStep: e.value))
                .toList(),
          ),
        )
      ],
    );
  }
}

enum StepStatus { completed, none, disabled, active, error }

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
