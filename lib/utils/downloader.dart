import 'dart:io';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sanitize_filename/sanitize_filename.dart';
import 'config.dart';

abstract class Downloader {
  static var downloading = [];

  static Future get(set) async {
    if (downloading.contains(set)) return Future.value();
    downloading.add(set);

    final Directory tempDir = await getTemporaryDirectory();
    //var name = p.basename(Uri.decodeFull(set['download']));
    var name = sanitizeFilename(set['name']);
    var tmpFileName = p.join(tempDir.path, name);
    var tmpFile = File(tmpFileName);
    final destinationDir = Directory(Config.path);

    final request = await HttpClient().getUrl(Uri.parse(set['download']));
    final response = await request.close();
    await response.pipe(tmpFile.openWrite());
    // if (response.statusCode == 200) {
    //   var bytes = await consolidateHttpClientResponseBytes(response);
    //   var file = File(tmpFileName);
    //   await file.writeAsBytes(bytes);
    // }

    try {
      Directory(p.join(Config.path, '__MACOSX')).deleteSync(recursive: true);
    } catch (e) {
      print(e);
    }
    try {
      Directory(p.join(Config.path, name.replaceAll('.zip', ''))).deleteSync(recursive: true);
    } catch (e) {
      print(e);
    }
    try {
      await ZipFile.extractToDirectory(zipFile: tmpFile, destinationDir: destinationDir);
    } catch (e) {
      print(e);
    }
    try {
      Directory(p.join(Config.path, '__MACOSX')).deleteSync(recursive: true);
    } catch (e) {
      print(e);
    }
    try {
      tmpFile.deleteSync();
    } catch (e) {
      print(e);
    }

    return Future.delayed(const Duration(milliseconds: 3000), () {
      downloading.remove(set);
    });
  }
}
