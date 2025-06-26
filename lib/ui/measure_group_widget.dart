import 'package:flutter/material.dart';
import 'package:valve_heights_app/domain/measure_controller.dart';
import 'package:valve_heights_app/domain/measure_group.dart';
import 'package:valve_heights_app/ui/measure_point_widget.dart';

class MeasureGroupWidget extends StatelessWidget {
  const MeasureGroupWidget({
    super.key,
    required this.group,
    this.rootPath,
    required this.controller,
  });

  final MeasureGroup group;
  final String? rootPath;
  final MeasureController controller;

  @override
  Widget build(BuildContext context) {
    final subGroup = group.subGroup;
    final points = group.points.values;

    final children = [
      ...group.ids.map((e) {
        final path = rootPath == null ? e : '$rootPath.$e';
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
                  controller: controller,
                ),
              if (points.isNotEmpty)
                ...points.map(
                  (p) => MeasurePointWidget(
                    point: p,
                    rootPath: path,
                    controller: controller,
                  ),
                ),
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
