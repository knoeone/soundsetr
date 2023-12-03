import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
// import 'package:plist_parser/plist_parser.dart';
import 'package:crypto/crypto.dart';
import 'package:sanitize_filename/sanitize_filename.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watcher/watcher.dart';
import '../models/soundset/soundset.dart';
import 'config.dart';
import 'dart:io' as io;

// const MD_PATH = '/Users/spacedevin/Projects/knoeone/soundsetr/CONTRIBUTING.md';
const MD_PATH = null;

class DownloaderSendResponse {
  final List files;
  final String path;

  DownloaderSendResponse({
    required this.files,
    required this.path,
  });
}

abstract class Downloader {
  static reveal(String file) async {
    launchUrl(Uri.parse(file.indexOf('https://') == 0 ? file : 'file://$file'));
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
          // var plist = PlistParser().parseFileSync(path.join(file.path, 'soundset.plist'));
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
      // var re = RegExp(r"https://github.com/(.*)/(.*)");
      // re.hasMatch(repository);

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
      if (MD_PATH != null) {
        File file = File(
          path.join(
            path.absolute(MD_PATH, 'CONTRIBUTING.md'),
          ),
        );
        String md = await file.readAsString();
        return md;
      } else {
        final request = await HttpClient().getUrl(
          Uri.parse(
            'https://raw.githubusercontent.com/knoeone/soundsetr/main/CONTRIBUTING.md',
          ),
        );
        final response = await request.close();
        final String md = await response.transform(utf8.decoder).join();
        return md;
      }
    } catch (e) {
      print(e);
    }
  }

  static Future readmeMd() async {
    try {
      if (MD_PATH != null) {
        File file = File(
          path.join(
            path.absolute(
              MD_PATH,
              'README.md',
            ),
          ),
        );
        String md = await file.readAsString();
        return md;
      } else {
        final request = await HttpClient().getUrl(
          Uri.parse(
            'https://raw.githubusercontent.com/knoeone/soundsetr/main/README.md',
          ),
        );
        final response = await request.close();
        final String md = await response.transform(utf8.decoder).join();
        return md;
      }
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
    set.savePlist();
  }
}
