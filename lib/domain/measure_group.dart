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


  Map<String, dynamic> toMap() {
    return {
      'ids': ids,
      'subGroup': subGroup?.toMap(),
      'points': points.map((key, value) => MapEntry(key, value.toMap())),
      'resultPosition': [
        resultPosition.dx.toStringAsFixed(1),
        resultPosition.dy.toStringAsFixed(1),
      ],
      'iterationRule': iterationRule.index,
      'step': step,
    };
  }

  factory MeasureGroup.fromMap(Map<String, dynamic> map) {
    return MeasureGroup(
      ids: List<String>.from(map['ids']),
      subGroup: map['subGroup'] != null
        ? MeasureGroup.fromMap(Map<String, dynamic>.from(map['subGroup']))
        : null,
      points: Map<String, MeasurePoint>.fromEntries(
        (map['points'] as Map<String, dynamic>).entries.map((e) {
          return MapEntry(
            e.key,
            MeasurePoint.fromMap(Map<String, dynamic>.from(e.value)),
          );
        }),
      ),
      resultPosition: Offset(
        double.parse(map['resultPosition'][0]),
        double.parse(map['resultPosition'][1]),
      ),
      iterationRule: IterationRule.values[map['iterationRule']],
      step: map['step'],
    );
  }
}

enum IterationRule { iterateX, iterateY }
