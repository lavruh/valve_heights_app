import 'package:flutter/material.dart';
import 'package:valve_heights_app/domain/measure_controller.dart';
import 'package:valve_heights_app/domain/measure_group.dart';
import 'package:valve_heights_app/ui/measure_group_widget.dart';

class ValveHeightsInputWidget extends StatefulWidget {
  const ValveHeightsInputWidget({super.key, required this.controller});
  final MeasureController controller;
  @override
  State<ValveHeightsInputWidget> createState() =>
      _ValveHeightsInputWidgetState();
}

class _ValveHeightsInputWidgetState extends State<ValveHeightsInputWidget> {
  late MeasureGroup root;

  @override
  void initState() {
    root = widget.controller.root;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FittedBox(child: MeasureGroupWidget(group: root, controller: widget.controller)),
    );
  }
}
