import 'package:flutter/material.dart';
import 'package:valve_heights_app/domain/measure_controller.dart';
import 'package:valve_heights_app/domain/measure_point.dart';

class MeasurePointWidget extends StatefulWidget {
  const MeasurePointWidget({
    super.key,
    required this.point,
    required this.rootPath,
    required this.controller,
  });
  final MeasurePoint point;
  final String rootPath;
  final MeasureController controller;

  @override
  State<MeasurePointWidget> createState() => _MeasurePointWidgetState();
}

class _MeasurePointWidgetState extends State<MeasurePointWidget> {
  TextEditingController textController = TextEditingController();
  String oldValue = '';

  final node = FocusNode();

  @override
  void initState() {
    super.initState();
    node.addListener(() {
      if (node.hasFocus) {
        textController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: textController.text.length,
        );
      }
    });
  }

  @override
  void dispose() {
    textController.dispose();
    node.dispose(); // Always dispose of FocusNodes!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final path = '${widget.rootPath}.${widget.point.name}';
    // oldValue = textController.text;

    widget.controller.setupNodes(path: path, node: node);
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        width: 55,
        child: TextField(
          controller: textController,
          onTap: () => widget.controller.setNodeInSequence(path),
          keyboardType: widget.controller.showKeyboard
              ? TextInputType.number
              : TextInputType.none,
          decoration: InputDecoration(labelText: widget.point.name),
          focusNode: node,
          onSubmitted: (v) {
            final d = double.tryParse(v);
            if (d != null) {
              widget.controller.setValue(value: d, path: path);
              final nextNode = widget.controller.getNextNode(currentPath: path);
              FocusScope.of(context).requestFocus(nextNode);
            }
          },
        ),
      ),
    );
  }
}
