import 'package:flutter/material.dart';

class MeasurePoint {
  final String name;
  final Offset offsetFromParent;

  MeasurePoint({required this.name, required this.offsetFromParent});

  MeasurePoint copyWith({String? name, Offset? offsetFromParent}) {
    return MeasurePoint(
      name: name ?? this.name,
      offsetFromParent: offsetFromParent ?? this.offsetFromParent,
    );
  }
}
