import 'package:flutter/material.dart';
import 'package:valve_heights_app/domain/measure_controller.dart';
import 'package:valve_heights_app/domain/measure_group.dart';
import 'package:valve_heights_app/ui/measure_point_widget.dart';

class MeasureGroupWidget extends StatelessWidget {
  const MeasureGroupWidget({
    super.key,
    required this.group,
    this.rootPath,
    required this.exportPosition,
    required this.controller,
  });

  final MeasureGroup group;
  final String? rootPath;
  final MeasureController controller;
  final Offset exportPosition;

  @override
  Widget build(BuildContext context) {
    final subGroup = group.subGroup;
    final points = group.points.values;
    final startX = exportPosition.dx;
    final startY = exportPosition.dy;
    int i = 0;
    final children = [
      ...group.ids.map((e) {
        final path = rootPath == null ? e : '$rootPath.$e';
        final step = group.step;
        Offset exportPosition = Offset(startX, startY);
        if (group.iterationRule == IterationRule.iterateY) {
          exportPosition = Offset(startX, startY + step * i);
        } else {
          exportPosition = Offset(startX + step * i, startY);
        }
        i++;
        return Card(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: const EdgeInsets.all(8.0), child: Text(e)),
              if (subGroup != null)
                MeasureGroupWidget(
                  group: subGroup,
                  rootPath: path,
                  exportPosition: exportPosition,
                  controller: controller,
                ),
              if (points.isNotEmpty)
                ...points.map((p) {
                  return MeasurePointWidget(
                    point: p.copyWith(exportPosition: exportPosition),
                    rootPath: path,
                    controller: controller,
                  );
                }),
            ],
          ),
        );
      }),
    ];
    final axis = (group.iterationRule == IterationRule.iterateX)
        ? Axis.horizontal
        : Axis.vertical;
    return Flex(
      direction: axis,
      mainAxisAlignment: MainAxisAlignment.start,
      children: children,
    );
  }
}
