import 'package:flutter/material.dart';

class MeasurePoint {
  final String name;
  final Offset offsetFromParent;
  final Offset? exportPosition;
  final FocusNode? node;
  final double? value;

  MeasurePoint({
    required this.name,
    required this.offsetFromParent,
    this.exportPosition,
    this.node,
    this.value,
  });

  @override
  String toString() {
    return '$name: value $value > $exportPosition \n';
  }

  MeasurePoint copyWith({
    String? name,
    Offset? offsetFromParent,
    Offset? exportPosition,
    FocusNode? node,
    double? value,
  }) {
    return MeasurePoint(
      name: name ?? this.name,
      offsetFromParent: offsetFromParent ?? this.offsetFromParent,
      exportPosition: exportPosition ?? this.exportPosition,
      node: node ?? this.node,
      value: value,
    );
  }
}
