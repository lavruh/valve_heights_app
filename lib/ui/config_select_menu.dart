import 'dart:io';
import "package:path/path.dart" as p;
import 'package:flutter/material.dart';

class ConfigSelectMenu extends StatefulWidget {
  const ConfigSelectMenu({
    super.key,
    required this.onConfigSelected,
    required this.confDir,
    required this.initConfig,
  });
  final Directory confDir;
  final String initConfig;
  final Function(String) onConfigSelected;

  @override
  State<ConfigSelectMenu> createState() => _ConfigSelectMenuState();
}

class _ConfigSelectMenuState extends State<ConfigSelectMenu> {
  List<String> _configs = [];
  String? _selectedFile;

  @override
  initState() {
    _selectedFile = widget.initConfig;
    super.initState();
    if (_configs.isEmpty) init();
  }

  init() {
    _configs = widget.confDir
        .listSync()
        .where((element) => element.path.endsWith(".json"))
        .map((e) => p.basenameWithoutExtension(e.path))
        .toList();
    _selectedFile = _configs.first;
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedFile,
          style: const TextStyle(color: Colors.deepPurple, fontSize: 16),
          onChanged: (String? newValue) {
            if (newValue == null) return;
            _selectedFile = newValue;
            widget.onConfigSelected("$newValue.json");
            setState(() {});
          },
          items: _configs.map<DropdownMenuItem<String>>((String file) {
            return DropdownMenuItem<String>(value: file, child: Text(file));
          }).toList(),
        ),
      ),
    );
  }
}
