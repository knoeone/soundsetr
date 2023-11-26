import 'dart:io';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:io/io.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sanitize_filename/sanitize_filename.dart';
import 'package:url_launcher/url_launcher.dart';
import 'config.dart';

abstract class Downloader {
  static var downloading = [];

  static dstName(name) {
    return path.join(Config.path, '${sanitizeFilename(name).replaceAll('.zip', '')}.eragesoundset');
  }

  static exists(set) {
    return Directory(dstName(set['name'])).existsSync();
  }

  static Future get(set) async {
    if (downloading.contains(set)) return Future.value();
    downloading.add(set);

    final Directory tempDir = await getTemporaryDirectory();
    //var name = p.basename(Uri.decodeFull(set['download']));
    var name = sanitizeFilename(set['name']);
    var tmpFileName = path.join(tempDir.path, name);
    var tmpFile = File(tmpFileName);
    final destinationDir = Directory(Config.path);
    final destinationFile = dstName(set['name']);

    final request = await HttpClient().getUrl(Uri.parse(set['download']));
    final response = await request.close();
    await response.pipe(tmpFile.openWrite());
    // if (response.statusCode == 200) {
    //   var bytes = await consolidateHttpClientResponseBytes(response);
    //   var file = File(tmpFileName);
    //   await file.writeAsBytes(bytes);
    // }

    //https://pub.dev/packages/accessing_security_scoped_resource

    try {
      Directory(path.join(Config.path, '__MACOSX')).deleteSync(recursive: true);
    } catch (e) {
      print(e);
    }
    try {
      Directory(destinationFile).deleteSync(recursive: true);
    } catch (e) {
      print(e);
    }
    try {
      await ZipFile.extractToDirectory(zipFile: tmpFile, destinationDir: destinationDir);
    } catch (e) {
      print(e);
    }
    try {
      Directory(path.join(Config.path, '__MACOSX')).deleteSync(recursive: true);
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

  static duplicate(set, name) {
    var dst = dstName(name);

    if (Directory(dst).existsSync()) {
      dst.deleteSync(recursive: true);
    }

    copyPathSync(set['path'], dst);
  }

  static delete(set) {
    var dst = dstName(set['name']);

    Directory(dst).deleteSync(recursive: true);
  }

  static download(set, file) async {
    final Directory? downloads = await getDownloadsDirectory();
    // final request = await HttpClient().getUrl(Uri.parse(file));
    // final response = await request.close();
    // await response.pipe(tmpFile.openWrite());
    //copyPathSync(set['path'], path.join('$downloads', file));
  }

  static reveal(file) async {
    launchUrl(Uri.parse(path.join('file://$file')));
  }
}
