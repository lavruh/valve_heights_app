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

  final node = FocusNode();

  @override
  void initState() {
    super.initState();
    setValue();
    node.addListener(() {
      if (node.hasFocus) {
        textController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: textController.text.length,
        );
      }
    });
  }

  void setValue() {
    if (widget.controller.values.containsKey(
      '${widget.rootPath}.${widget.point.name}',
    )) {
      textController.text = widget
          .controller
          .values['${widget.rootPath}.${widget.point.name}']
          .toString();
    } else {
      textController.text = "";
    }
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
    setValue();
    final exportPos =
        widget.point.exportPosition! + widget.point.offsetFromParent;
    widget.controller.setNode(path: path, node: node);
    widget.controller.setExportPosition(path: path, position: exportPos);
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
              widget.controller.setValue(path: path, value: d);
              final nextNode = widget.controller.getNextNode(currentPath: path);
              FocusScope.of(context).requestFocus(nextNode);
            }
          },
        ),
      ),
    );
  }
}
