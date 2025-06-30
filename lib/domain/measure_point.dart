import 'package:flutter/material.dart';

class MeasurePoint {
  final String name;
  final Offset offsetFromParent;
  final Offset? exportPosition;

  MeasurePoint({
    required this.name,
    required this.offsetFromParent,
    this.exportPosition,
  });


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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'offsetFromParent': '${offsetFromParent.dx.toStringAsFixed(1)},${offsetFromParent.dy.toStringAsFixed(1)}',
      'exportPosition': exportPosition == null
        ? null
        : '${exportPosition!.dx.toStringAsFixed(1)},${exportPosition!.dy.toStringAsFixed(1)}',
    };
  }

  factory MeasurePoint.fromMap(Map<String, dynamic> map) {
    return MeasurePoint(
      name: map['name'],
      offsetFromParent: Offset(
        double.parse(map['offsetFromParent'].split(',')[0]),
        double.parse(map['offsetFromParent'].split(',')[1]),
      ),
      exportPosition: map['exportPosition'] == null
        ? null
        : Offset(
          double.parse(map['exportPosition'].split(',')[0]),
          double.parse(map['exportPosition'].split(',')[1]),
        ),
    );
  }
}
