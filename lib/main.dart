import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valve_heights_app/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (await handlePermissions()) runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Valve heights',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: FutureBuilder<String>(
        future: init(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text(snapshot.error.toString())),
            );
          }
          final pathConfigs = snapshot.data;
          if (pathConfigs == null) {
            return Scaffold(
              body: Center(child: Text('Could not setup config directory')),
            );
          }
          return MainScreen(pathConfigs: pathConfigs);
        },
      ),
    );
  }

  Future<String> init() async {
    final prefs = await SharedPreferences.getInstance();
    // prefs.setString('pathConfigs', '');
    await prefs.clear();
    String? pathConfigs = prefs.getString('pathConfigs');
    pathConfigs ??= await setupConfigDirectory(pathConfigs, prefs);
    if (pathConfigs == null) {
      throw Exception('Could not setup config directory');
    }
    return pathConfigs;
  }

  Future<String?> setupConfigDirectory(
    String? pathConfigs,
    SharedPreferences prefs,
  ) async {
    if (Platform.isAndroid) {
      pathConfigs = "/storage/emulated/0/valve_heights_app";
    }
    if (Platform.isWindows || Platform.isLinux) {
      final docDir = await getApplicationDocumentsDirectory();
      pathConfigs = p.join(docDir.path, 'valve_heights_app', 'configs');
    }
    final directory = Directory(pathConfigs!);
    if (!directory.existsSync()) {
      await directory.create(recursive: true);
    }
    pathConfigs = directory.path;
    await prefs.setString('pathConfigs', directory.path);
    final assetConfigFiles = await loadAssetFiles();

    for (final assetPath in assetConfigFiles) {
      final fileName = p.basename(assetPath);
      final filePath = p.join(pathConfigs, fileName);
      final file = File(filePath);

      if (!file.existsSync()) {
        final byteData = await rootBundle.load(assetPath);
        final buffer = byteData.buffer;
        await file.writeAsBytes(
          buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
        );
      }
    }
    return pathConfigs;
  }

  Future<List<String>> loadAssetFiles() async {
    final String manifestContent = await rootBundle.loadString(
      'AssetManifest.json',
    );
    final Map<String, dynamic> manifestMap = jsonDecode(manifestContent);

    List<String> files = manifestMap.keys
        .where((String key) => key.contains('.json'))
        .map((String key) => key)
        .toList();

    files = files.toSet().toList();
    files.sort();

    return files;
  }
}

Future<bool> handlePermissions() async {
  if (Platform.isWindows || Platform.isLinux) return true;
  if (await Permission.manageExternalStorage.status.isDenied) {
    await Permission.manageExternalStorage.request().isGranted;
  }
  return true;
}
