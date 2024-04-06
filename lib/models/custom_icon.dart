import 'package:flutter/material.dart';

class CustomIcon{
  late IconData iconData;
  late bool picked;

  CustomIcon({
    required this.iconData,
    this.picked = false
  });
}