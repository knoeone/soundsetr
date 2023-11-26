import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:io/io.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:plist_parser/plist_parser.dart';
import 'package:crypto/crypto.dart';
import 'package:sanitize_filename/sanitize_filename.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watcher/watcher.dart';
import '../models/soundset.dart';
import 'config.dart';
import 'dart:io' as io;

abstract class Downloader {
  static var downloading = [];

  static dstName(name) {
    return path.join(Config.path, '${sanitizeFilename(name).replaceAll('.zip', '')}.eragesoundset');
  }

  static exists(SoundSet set) {
    return Directory(dstName(set.name)).existsSync();
  }

  static Future saveAudio(SoundSet set, name) async {
    final Directory tempDir = await getDownloadsDirectory() as Directory;
    var tmpFileName = path.join(tempDir.path, '${set.name} - ${set.plist![name]}');
    var currentFile = File(path.join(set.path as String, set.plist![name]));

    currentFile.copySync(tmpFileName);
    reveal(tempDir.path);
  }

  static Future preview(SoundSet set) async {
    var appTempDir = 'soundsets';
    final Directory tempDir = await getTemporaryDirectory();
    var name = sha1.convert(utf8.encode(set.download as String)).toString();
    var tmpFileName = path.join(tempDir.path, appTempDir, '$name.zip');
    var tmpFile = File(tmpFileName);
    var tmpDirName = path.join(tempDir.path, appTempDir, name);

    try {
      await Directory(path.join(tempDir.path, appTempDir)).create();
    } catch (e) {
      print(e);
    }

    final request = await HttpClient().getUrl(Uri.parse(set.download as String));
    final response = await request.close();
    await response.pipe(tmpFile.openWrite());

    try {
      await ZipFile.extractToDirectory(zipFile: tmpFile, destinationDir: Directory(tmpDirName));
    } catch (e) {
      print(e);
    }
    try {
      tmpFile.deleteSync();
    } catch (e) {
      print(e);
    }

    var extractedDir = Directory(tmpDirName).listSync().firstWhere(
          (file) => path.basename(file.path).endsWith('.eragesoundset'),
        );
    print(extractedDir);

    set.path = extractedDir.path;
    set.tmp = true;
    return set;
  }

  static Future get(set) async {
    if (downloading.contains(set)) return Future.value();
    downloading.add(set);

    final Directory tempDir = await getTemporaryDirectory();
    //var name = p.basename(Uri.decodeFull(set['download']));
    var name = sanitizeFilename(set.name);
    var tmpFileName = path.join(tempDir.path, name);
    var tmpFile = File(tmpFileName);
    final destinationDir = Directory(Config.path);
    final destinationFile = dstName(set.name);

    final request = await HttpClient().getUrl(Uri.parse(set.download));
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

  static newFromDefault(name) {
    var cleanName = sanitizeFilename(name);
    final destinationFile = dstName(cleanName);

    Directory(destinationFile).createSync();

    var plist = """
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>SoundSetFileFormatVersion</key>
  <integer>0</integer>
  <key>SoundSetUserString</key>
  <string>Created by Soundsetr</string>
  <key>SoundSetURL</key>
  <string>http://www.microsoft.com/mac</string>
  <key>SoundFile_MailError</key>
  <string>mailerror.wav</string>
  <key>SoundFile_MailSent</key>
  <string>mailsent.wav</string>
  <key>SoundFile_NewMail</key>
  <string>newmail.wav</string>
  <key>SoundFile_NoMail</key>
  <string>nomail.wav</string>
  <key>SoundFile_Reminder</key>
  <string>reminder.wav</string>
  <key>SoundFile_Welcome</key>
  <string>welcome.wav</string>
</dict>
</plist>
""";

    void copyFile(name) => File(path.join(Config.outlookResourcePath, name))
        .copySync(path.join(destinationFile, name));
    for (var file in [
      'mailerror.wav',
      'mailsent.wav',
      'newmail.wav',
      'nomail.wav',
      'reminder.wav',
      'welcome.wav',
    ]) {
      copyFile(file);
    }

    File(path.join(destinationFile, 'soundset.plist')).writeAsStringSync(plist);
  }

  static duplicate(SoundSet set, name) {
    var dst = dstName(name);

    if (Directory(dst).existsSync()) {
      dst.deleteSync(recursive: true);
    }

    copyPathSync(set.path as String, dst);
  }

  static delete(SoundSet set) {
    var dst = dstName(set.name);

    Directory(dst).deleteSync(recursive: true);
  }

  static download(SoundSet set, file) async {
    final Directory? downloads = await getDownloadsDirectory();
    // final request = await HttpClient().getUrl(Uri.parse(file));
    // final response = await request.close();
    // await response.pipe(tmpFile.openWrite());
    //copyPathSync(set['path'], path.join('$downloads', file));
  }

  static reveal(String file) async {
    launchUrl(Uri.parse(file.indexOf('https://') == 0 ? file : 'file://$file'));
  }

  static replace(SoundSet set, name) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['aif', 'wav', 'mp3', 'ogg', 'aiff', 'flac', 'm4a'],
    );

    if (result == null) return;

    File file = File(result.files.single.path!);

    final Directory downloads = await getTemporaryDirectory();
    final tmpFile = path.join(downloads.path, 'converted.aif');
    final session = await FFmpegKit.execute('-y -i "${file.path}" "$tmpFile"');
    final returnCode = await session.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {
      // SUCCESS
    } else if (ReturnCode.isCancel(returnCode)) {
      // CANCEL
    } else {
      // ERROR
    }

    final destinationFile = path.join(dstName(set.name), set.plist![name]);

    File(destinationFile).deleteSync();
    File(tmpFile).renameSync(destinationFile);
  }

  static watchFiles() {
    var controller = StreamController();
    DirectoryWatcher watcher;
    StreamSubscription? listener;

    void updateFiles(directory, [WatchEvent? e]) {
      var files = [];

      try {
        if (!Directory(directory).existsSync()) {
          if (listener != null) {
            controller.add([]);
            listener!.cancel();
            listener = null;
            print("return");
            return;
          }
        }

        io.Directory(directory).listSync().forEach((file) async {
          bool isFile = file is File;
          //bool isZip = isFile && p.basename(file.path).endsWith('.zip');
          var name = path.basename(file.path);
          //if (isFile && !isZip) return;
          if (isFile) return;
          if (!name.contains('eragesoundset')) return;
          var plist = PlistParser().parseFileSync(path.join(file.path, 'soundset.plist'));
          files.add(SoundSet.fromPath(name, file.path));
        });
        controller.add(files..sort((a, b) => a.name.compareTo(b.name)));
      } catch (e) {
        print(e);
      }
    }

    Config.prefs.getString('path', defaultValue: '').listen((directory) {
      if (!Directory(directory).existsSync()) {
        controller.add([]);
        return;
      }

      watcher = DirectoryWatcher(path.absolute(directory));
      listener = watcher.events.listen((e) => updateFiles(directory, e));

      updateFiles(directory);
    });

    return controller.stream;
  }

  static watchNetwork() {
    var controller = StreamController();

    Config.prefs.getString('repository', defaultValue: '').listen((repository) async {
      try {
        final request = await HttpClient().getUrl(Uri.parse(repository));
        final response = await request.close();
        final List json = jsonDecode(await response.transform(utf8.decoder).join());
        print(json);
        var sets = [];
        for (var item in json) {
          sets.add(SoundSet.fromJson(item));
        }
        controller.add(sets..sort((a, b) => a.name.compareTo(b.name)));
      } catch (e) {
        controller.add([]);
        print(e);
      }
    });

    return controller.stream;
  }
}
