import 'package:flutter/material.dart';

class CustomButton {
  final Widget Function(String?) child;
  final Color? highlightColor;
  final Color? splashColor;
  final Color? color;
  final ShapeBorder? shape;
  final double? width;
  final double? height;
  CustomButton({
    required this.child,
    this.highlightColor,
    this.splashColor,
    this.color,
    this.shape,
    this.width,
    this.height,
  });
}
