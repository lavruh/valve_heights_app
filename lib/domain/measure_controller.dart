import 'package:flutter/material.dart';
import 'package:valve_heights_app/domain/measure_group.dart';
import 'package:valve_heights_app/domain/measure_point.dart';
import 'package:valve_heights_app/domain/measure_sequence.dart';

const reportStartPoint = Offset(4, 7);

class MeasureController extends ChangeNotifier {
  Map<String, double> values = {};
  Map<String, FocusNode> nodes = {};

  bool showKeyboard = false;

  MeasureGroup root = MeasureGroup(
    ids: ['A', 'B'],
    resultPosition: reportStartPoint,
    step: 6,

    subGroup: MeasureGroup(
      ids: ['1', '2', '3', '4', '5', '6'],
      iterationRule: IterationRule.iterateY,
      step: 1,
      resultPosition: reportStartPoint,
      subGroup: MeasureGroup(
        points: {
          'stem': MeasurePoint(name: 'stem', offsetFromParent: Offset(0, 0)),
          'rotator': MeasurePoint(
            name: 'rotator',
            offsetFromParent: Offset(0, 0),
          ),
        },
        ids: ['A', 'B', 'C', 'D'],
        resultPosition: reportStartPoint,
        iterationRule: IterationRule.iterateY,
        step: 1,
      ),
    ),
  );

  MeasureSequence sequence = MeasureSequence(
    sequence: [
      "A.1",
      "B.1",
      "A.5",
      "B.5",
      "A.3",
      "B.3",
      "A.6",
      "B.6",
      "A.2",
      "B.2",
      "A.4",
      "B.4",
    ],
    subSequence: MeasureSequence(
      sequence: [
        "D.stem",
        "C.stem",
        "A.stem",
        "B.stem",
        "D.rotator",
        "C.rotator",
        "A.rotator",
        "B.rotator",
      ],
    ),
  );

  setupNodes({required String path, required FocusNode node}) {
    nodes[path] = node;
  }

  void setValue({required double value, required String path}) {
    values[path] = value;
  }

  setNodeInSequence(String currentPath) {
    final current = sequence.getCurrentPath();
    if (currentPath != current) {
      sequence.setCurrentPath(currentPath);
    }
  }

  FocusNode getNextNode({required String currentPath}) {
    final nextPath = sequence.generateNextPath();
    // print(nextPath);
    return nodes[nextPath]!;
  }

  void toggleShowKeyboard() {
    showKeyboard = !showKeyboard;
    notifyListeners();
  }
}
