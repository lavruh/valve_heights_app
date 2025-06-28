import 'package:flutter/material.dart';
import 'package:valve_heights_app/domain/measure_controller.dart';
import 'package:valve_heights_app/ui/valve_heights_input_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  MeasureController controller = MeasureController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Valve heights'),
        actions: [
          IconButton(
            onPressed: () => controller.exportReport(context),
            icon: Icon(Icons.download),
          ),
          IconButton(
            icon: Icon(
              controller.showKeyboard
                  ? Icons.keyboard_hide
                  : Icons.keyboard_alt,
            ),
            onPressed: () => controller.toggleShowKeyboard(),
          ),
        ],
      ),
      body: ValveHeightsInputWidget(controller: controller),
    );
  }

  showInSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
