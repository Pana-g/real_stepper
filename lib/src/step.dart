import 'package:flutter/material.dart';

class RealStep {
  final String? titleText;
  final Widget? title;
  // final Widget? subTitle;
  // final String? subTitleText;
  final Widget? icon;
  final Widget? content;
  final String? error;
  final bool disabled;

  const RealStep({
    this.titleText,
    // this.subTitleText,
    this.title,
    // this.subTitle,
    this.icon,
    this.content,
    this.error,
    this.disabled = false,
  });
}
