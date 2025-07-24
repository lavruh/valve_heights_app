import 'dart:convert';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_provider/file_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valve_heights_app/domain/measure_group.dart';
import 'package:valve_heights_app/domain/measure_point.dart';
import 'package:valve_heights_app/domain/measure_sequence.dart';

const reportStartPoint = Offset(3, 6);

class MeasureController extends ChangeNotifier {
  Map<String, double> values = {};
  Map<String, FocusNode> nodes = {};
  Map<String, Offset> exportPositions = {};

  bool showKeyboard = true;
  SharedPreferences? prefs;

  MeasureController({
    MeasureGroup? root,
    MeasureSequence? sequence,
    Map<String, double>? values,
    this.prefs,
  }) : root =
           root ??
           MeasureGroup(
             ids: ['A', 'B'],
             resultPosition: reportStartPoint,
             step: 8,

             subGroup: MeasureGroup(
               ids: ['1', '2', '3', '4', '5', '6'],
               iterationRule: IterationRule.iterateY,
               step: 4,
               resultPosition: reportStartPoint,
               subGroup: MeasureGroup(
                 points: {
                   'stem': MeasurePoint(
                     name: 'stem',
                     offsetFromParent: Offset(0, 0),
                   ),
                   'rotator': MeasurePoint(
                     name: 'rotator',
                     offsetFromParent: Offset(1, 0),
                   ),
                 },
                 ids: ['A', 'B', 'C', 'D'],
                 resultPosition: reportStartPoint,
                 iterationRule: IterationRule.iterateY,
                 step: 1,
               ),
             ),
           ),
       sequence =
           sequence ??
           MeasureSequence(
             sequence: [
               "A.1",
               "B.1",
               "A.5",
               "B.5",
               "A.3",
               "B.3",
               "A.6",
               "B.6",
               "A.2",
               "B.2",
               "A.4",
               "B.4",
             ],
             subSequence: MeasureSequence(
               sequence: [
                 "D.stem",
                 "C.stem",
                 "A.stem",
                 "B.stem",
                 "D.rotator",
                 "C.rotator",
                 "A.rotator",
                 "B.rotator",
               ],
             ),
           ),
       values = values ?? {} {
    _init();
  }

  late MeasureGroup root;
  late MeasureSequence sequence;

  setNode({required String path, required FocusNode node}) {
    nodes[path] = node;
  }

  void setValue({required double value, required String path}) {
    values[path] = value;
    saveState();
  }

  setExportPosition({required String path, required Offset position}) {
    exportPositions[path] = position;
  }

  setNodeInSequence(String currentPath) {
    final current = sequence.getCurrentPath();
    if (currentPath != current) {
      sequence.setCurrentPath(currentPath);
    }
  }

  FocusNode getNextNode({required String currentPath}) {
    final nextPath = sequence.generateNextPath();
    final node = nodes[nextPath];
    if (node == null) throw MeasureControllerException("Path does not exist");
    return node;
  }

  void toggleShowKeyboard() {
    showKeyboard = !showKeyboard;
    notifyListeners();
  }

  void exportReport() async {
    final data = await rootBundle.load('assets/template.xlsx');
    final bytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );
    final excel = Excel.decodeBytes(bytes);
    final table = excel.tables["Sheet1"];
    if (table == null) return;

    for (final k in values.keys) {
      final val = values[k];
      final pos = exportPositions[k];
      if (val == null || pos == null) continue;
      var cell = table.cell(
        CellIndex.indexByColumnRow(
          columnIndex: pos.dx.round(),
          rowIndex: pos.dy.round(),
        ),
      );
      final stemStyle = cell.cellStyle;
      cell.value = DoubleCellValue(val);
      cell.cellStyle = stemStyle;
    }

    if (kIsWeb) {
      excel.save(fileName: "measurement.xlsx");
    } else {
      final fileBytes = excel.save();
      if (fileBytes == null) return;
      final IFileProvider fileProvider = FileProvider.getInstance();
      final dateString = DateFormat("yyyy-MM-dd").format(DateTime.now());
      fileProvider.saveDataToFile(
        data: Uint8List.fromList(fileBytes),
        fileName: "$dateString export.xlsx",
        allowedExtensions: [".xlsx"],
      );
    }
  }

  Map<String, dynamic> toMap() {
    return {"root": root.toMap(), "sequence": sequence.toMap()};
  }

  factory MeasureController.fromMap(Map<String, dynamic> map) {
    return MeasureController(
      root: MeasureGroup.fromMap(map["root"]),
      sequence: MeasureSequence.fromMap(map["sequence"]),
    );
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory MeasureController.fromJson(String source) {
    return MeasureController.fromMap(jsonDecode(source));
  }

  Future<void> saveConfigFile(BuildContext context) async {
    final String jsonContent = toJson();
    final IFileProvider fileProvider = FileProvider.getInstance();
    final file = await fileProvider.selectFile(
      context: context,
      title: "Select location to save config",
      allowedExtensions: ["json"],
    );
    String path = file.path.split(".")[0];
    File("$path.json")
      ..createSync(recursive: true)
      ..writeAsStringSync(jsonContent);
  }

  @override
  void dispose() {
    super.dispose();
    nodes.clear();
    values.clear();
    exportPositions.clear();
  }

  void saveState() async {
    final json = jsonEncode(values);
    await prefs?.setString("values", json);
  }

  void loadState() async {
    final jsonString = prefs?.getString("values");
    if (jsonString != null) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(jsonString);
        decoded.forEach((key, value) {
          if (value is num) {
            values[key] = value.toDouble();
          } else if (value is String) {
            values[key] = double.tryParse(value) ?? 0.0;
          }
        });
        notifyListeners();
      } catch (e) {
        MeasureControllerException('Error loading state: $e');
      }
    }
  }

  clearState() async {
    prefs?.remove("values");
    values.clear();
    notifyListeners();
  }

  _init() async {
    prefs ??= await SharedPreferences.getInstance();
    loadState();
  }
}

class MeasureControllerException implements Exception {
  final String message;

  const MeasureControllerException(this.message);

  @override
  String toString() => message;
}