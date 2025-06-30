import 'package:file_provider/file_provider.dart';
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

  Future<void> loadController(BuildContext context) async {
    try {
      final IFileProvider fileProvider = FileProvider.getInstance();
      final file = await fileProvider.selectFile(
        context: context,
        title: "Select config file",
        allowedExtensions: ["json"],
      );
      final jsonContent = await file.readAsString();
      setState(() {
        controller = MeasureController.fromJson(jsonContent);
      });
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load configuration: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () => loadController(context),
            child: Text("Load config"),
          ),
          TextButton(
            onPressed: () => controller.saveConfigFile(context),
            child: Text("Save config"),
          ),
          TextButton(
            child: Text("Generate report"),
            onPressed: () => controller.exportReport(context),
          ),
          IconButton(
            tooltip: "Show keyboard",
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
