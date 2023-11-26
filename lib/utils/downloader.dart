import 'dart:io';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:io/io.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:plist_parser/plist_parser.dart';
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
  <string>$name</string>
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
    [
      'mailerror.wav',
      'mailsent.wav',
      'newmail.wav',
      'nomail.wav',
      'reminder.wav',
      'welcome.wav',
    ].forEach((file) => copyFile(file));

    File(path.join(destinationFile, 'soundset.plist')).writeAsStringSync(plist);
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

  static replace(set, name) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['aif', 'wav', 'mp3', 'ogg', 'aiff', 'flac', 'm4a'],
    );

    if (result == null) return;

    File file = File(result.files.single.path!);

    final Directory downloads = await getTemporaryDirectory();
    final tmpFile = path.join('${downloads.path}', 'converted.aif');
    final session = await FFmpegKit.execute('-y -i "${file.path}" "${tmpFile}"');
    final returnCode = await session.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {
      // SUCCESS
    } else if (ReturnCode.isCancel(returnCode)) {
      // CANCEL
    } else {
      // ERROR
    }

    final destinationFile = path.join(dstName(set['name']), set['plist'][name]);

    File(destinationFile).deleteSync();
    File(tmpFile).renameSync(destinationFile);
  }
}
