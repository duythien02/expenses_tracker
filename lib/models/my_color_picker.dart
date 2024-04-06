import 'package:flutter/material.dart';

class MyColorPicker {
  Color color;
  bool isSelected;

  MyColorPicker({
    required this.color,
    this.isSelected = false,
  });
}