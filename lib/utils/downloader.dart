import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:io/io.dart';
import 'package:macos_file_picker/macos_file_picker.dart';
import 'package:macos_file_picker/macos_file_picker_platform_interface.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:plist_parser/plist_parser.dart';
import 'package:crypto/crypto.dart';
import 'package:propertylistserialization/propertylistserialization.dart';
import 'package:sanitize_filename/sanitize_filename.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watcher/watcher.dart';
import '../models/soundset.dart';
import 'config.dart';
import 'dart:io' as io;

class DownloaderSendResponse {
  final List files;
  final String zip;
  final String path;

  DownloaderSendResponse({
    required this.files,
    required this.zip,
    required this.path,
  });
}

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

  static Future send(SoundSet set) async {
    var appTempDir = 'soundsets';

    final Directory tempDir = await getTemporaryDirectory();
    var name = sha1.convert(utf8.encode(set.name as String)).toString();

    var tmpDirName = path.join(tempDir.path, appTempDir, name, '${set.name}.eragesoundset');
    var zipFileName = path.join(tempDir.path, appTempDir, name, '${set.name}.eragesoundset.zip');

    try {
      await Directory(path.join(tempDir.path, appTempDir, name)).delete(recursive: true);
    } catch (e) {
      print(e);
    }

    try {
      await Directory(tmpDirName).create(recursive: true);
    } catch (e) {
      print(e);
    }

    var files = [
      set.plist!['SoundFile_MailError'],
      set.plist!['SoundFile_MailSent'],
      set.plist!['SoundFile_NewMail'],
      set.plist!['SoundFile_NoMail'],
      set.plist!['SoundFile_Reminder'],
      set.plist!['SoundFile_Welcome'],
      'soundset.plist',
    ];

    void copyFile(name) =>
        File(path.join(set.path as String, name)).copySync(path.join(tmpDirName, name));

    for (var file in files) {
      copyFile(file);
    }

    try {
      await ZipFile.createFromDirectory(
        sourceDir: Directory(tmpDirName),
        zipFile: File(zipFileName),
      );
    } catch (e) {
      print(e);
    }

    return DownloaderSendResponse(
      files: files,
      zip: zipFileName,
      path: path.join(tempDir.path, appTempDir, name),
    );
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
    var name = sanitizeFilename(set.name);
    var tmpFileName = path.join(tempDir.path, name);
    var tmpFile = File(tmpFileName);
    final destinationDir = Directory(Config.path);
    final destinationFile = dstName(set.name);

    final request = await HttpClient().getUrl(Uri.parse(set.download));
    final response = await request.close();
    await response.pipe(tmpFile.openWrite());

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

  static replaceSelect(SoundSet set, name) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['aif', 'wav', 'mp3', 'ogg', 'aiff', 'flac', 'm4a'],
    );

    // final _macosFilePickerPlugin = MacosFilePicker();

    // final result =
    //     await _macosFilePickerPlugin.pick(MacosFilePickerMode.fileAndFolder, allowsMultiple: false);

    if (result == null) return;
    File file = File(result.files.single.path!);

    return replace(set, name, file);
  }

  static replace(SoundSet set, name, file) async {
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

    var player = AudioPlayer();
    player.play(DeviceFileSource(destinationFile));
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

  static Future contributingMd() async {
    try {
      final request = await HttpClient().getUrl(
        Uri.parse(
          'https://raw.githubusercontent.com/knoeone/soundsetr/main/CONTRIBUTING.md',
        ),
      );
      final response = await request.close();
      final String md = await response.transform(utf8.decoder).join();

      // File file = File(
      //   path.join(
      //     path.absolute(io.Platform.environment['HOME'] as String,
      //         'Projects/knoeone/soundsetr/CONTRIBUTING.md'),
      //   ),
      // );
      // String md = await file.readAsString();
      return md;
    } catch (e) {
      print(e);
    }
  }

  static Future readmeMd() async {
    try {
      final request = await HttpClient().getUrl(
        Uri.parse(
          'https://raw.githubusercontent.com/knoeone/soundsetr/main/README.md',
        ),
      );
      final response = await request.close();
      final String md = await response.transform(utf8.decoder).join();

      // File file = File(
      //   path.join(
      //     path.absolute(
      //       io.Platform.environment['HOME'] as String,
      //       'Projects/knoeone/soundsetr/README.md',
      //     ),
      //   ),
      // );
      // String md = await file.readAsString();
      return md;
    } catch (e) {
      print(e);
    }
  }

  static saveSoundSet(SoundSet set) async {
    final sourceFilename = set.path as String;
    final sourcePathname = sourceFilename.replaceAll(path.basename(sourceFilename), '');
    final destinationFileName =
        path.join(sourcePathname, '${sanitizeFilename(set.name)}.eragesoundset');

    if (destinationFileName != set.path) {
      Directory(sourceFilename).renameSync(destinationFileName);
      set.path = destinationFileName;
    }
    SoundSet.savePlist(set);
  }
}
