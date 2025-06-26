import 'dart:ui';

import 'measure_point.dart';

class MeasureGroup {
  final List<String> ids;
  final MeasureGroup? subGroup;
  final Map<String, MeasurePoint> points;
  final Offset resultPosition;
  final IterationRule iterationRule;
  final int step;

  MeasureGroup({
    this.points = const {},
    required this.ids,
    this.subGroup,
    this.iterationRule = IterationRule.iterateX,
    required this.resultPosition,
    required this.step,
  });

  MeasureGroup copyWith({
    List<String>? ids,
    MeasureGroup? subGroup,
    Map<String, MeasurePoint>? points,
    Offset? resultPosition,
    int? step,
  }) {
    return MeasureGroup(
      points: points ?? this.points,
      ids: ids ?? this.ids,
      subGroup: subGroup ?? this.subGroup,
      resultPosition: resultPosition ?? this.resultPosition,
      step: step ?? this.step,
    );
  }
}

enum IterationRule { iterateX, iterateY }
