import 'package:flutter/material.dart';
import 'package:valve_heights_app/domain/measure_controller.dart';
import 'package:valve_heights_app/ui/measure_group_widget.dart';

class ValveHeightsInputWidget extends StatelessWidget {
  const ValveHeightsInputWidget({super.key, required this.controller});
  final MeasureController controller;

  @override
  Widget build(BuildContext context) {
    final root = controller.root;
    return SingleChildScrollView(
      child: FittedBox(
        child: MeasureGroupWidget(
          exportPosition: root.resultPosition,
          group: root,
          controller: controller,
        ),
      ),
    );
  }
}
