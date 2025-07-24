import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:file_provider/file_provider.dart';
import 'package:flutter/material.dart';
import 'package:valve_heights_app/domain/measure_controller.dart';
import 'package:valve_heights_app/ui/config_select_menu.dart';
import 'package:valve_heights_app/ui/valve_heights_input_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.pathConfigs});

  final String pathConfigs;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  MeasureController controller = MeasureController();
  late String _configPath;
  late Directory confDir;

  @override
  void initState() {
    confDir = Directory(widget.pathConfigs);
    _configPath = confDir.listSync().first.path;
    super.initState();
    controller.addListener(() => setState(() {}));
  }

  Future<void> loadController(BuildContext context) async {
    try {
      final IFileProvider fileProvider = FileProvider.getInstance();
      final file = await fileProvider.selectFile(
        context: context,
        title: "Select config file",
        allowedExtensions: ["json"],
      );
      await setConfigPath(file.path);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load configuration: $e')),
        );
      }
    }
  }

  _configFromJson(String jsonContent) {
    setState(() {
      final oldValues = controller.values;
      final showKeyboardState = controller.showKeyboard;
      controller.dispose();
      controller = MeasureController.fromJson(jsonContent);
      controller.addListener(() => setState(() {}));
      controller.showKeyboard = showKeyboardState;
      if (oldValues.isNotEmpty) {
        controller.values.addAll(oldValues);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Directory dir = confDir;
    final path = configPath;

    return Scaffold(
      appBar: AppBar(
        title: path != null
            ? ConfigSelectMenu(
                onConfigSelected: (pathToConfig) {
                  setConfigPath(pathToConfig);
                },
                confDir: dir,
                initConfig: path,
              )
            : null,
        actions: [
          IconButton(
            icon: Icon(Icons.clear_all),
            onPressed: () => newMeasurement(context),
            tooltip: "New measurement",
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            tooltip: "Generate report",
            onPressed: () => controller.exportReport(),
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

  String getConfigJson(String configName) {
    final pathToConfig = p.join(confDir.path, configName);
    return File(pathToConfig).readAsStringSync();
  }

  String? get configPath => _configPath;
  setConfigPath(String? value) async {
    if (value == _configPath || value == null) return;
    _configPath = value;
    final jsonContent = getConfigJson(value);
    _configFromJson(jsonContent);
  }

  Future<void> newMeasurement(BuildContext context) async {
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('New Measurement'),
        content: const Text('Clear all recorded data?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('CLEAR'),
          ),
        ],
      ),
    );
    if (shouldClear == true) {
      controller.clearState();
    }
  }
}
