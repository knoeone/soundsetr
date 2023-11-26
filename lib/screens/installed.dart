import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as path;
import 'package:plist_parser/plist_parser.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:watcher/watcher.dart';
import 'dart:io' as io;

import '../utils/config.dart';
import '../widgets/card.dart';
import '../widgets/search.dart';

class InstalledScreen extends StatefulWidget {
  final ScrollController? scrollController;
  const InstalledScreen({super.key, this.scrollController});

  @override
  _InstalledScreenState createState() => _InstalledScreenState();
}

class _InstalledScreenState extends State<InstalledScreen> {
  var directory = Config.path;
  var filter = '';
  var sets = [];
  var watcher;

  @override
  void initState() {
    super.initState();
    updateFiles();

    Config.prefs.getString('path', defaultValue: '').listen((value) {
      setState(() => directory = value);
      checkAndWatch();
      updateFiles();
    });
  }

  void checkAndWatch() {
    if (!Directory(directory).existsSync()) return;
    if (watcher == null) return;
    try {
      watcher = DirectoryWatcher(path.absolute(directory));
      watcher.events.listen((e) => updateFiles());
    } catch (e) {
      print(e);
    }
  }

  void updateFiles() {
    var files = [];

    try {
      if (!Directory(directory).existsSync()) {
        setState(() => sets = []);
        return;
      }

      io.Directory(directory).listSync().forEach((file) async {
        bool isFile = file is File;
        //bool isZip = isFile && p.basename(file.path).endsWith('.zip');
        var name = path.basename(file.path);
        //if (isFile && !isZip) return;
        if (isFile) return;
        if (!name.contains('eragesoundset')) return;
        var plist = PlistParser().parseFileSync(path.join(file.path, 'soundset.plist'));
        files.add({
          'name': name.replaceAll('.eragesoundset', ''),
          'description': plist['SoundSetUserString'],
          'repo': plist['SoundSetURL'],
          'path': file.path,
          'plist': plist
        });
      });

      setState(() {
        sets = files..sort((a, b) => a['name'].compareTo(b['name']));
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // return PreferenceBuilder(
    //     preference: Config.prefs.getString('path', defaultValue: ''),
    //     builder: (BuildContext context, String path) {
    //       return Text('Button pressed $path times!');
    //     });
    return Search(
      items: (filter) => sets
          .where(
            (item) =>
                filter == '' ||
                (item['name'] as String).contains(filter) ||
                (item['description'] as String).contains(filter),
          )
          .toList(),
      itemBuilder: (context, index, item) {
        return Card(
          title: '${item['name']}',
          description: '${item['description']}',
          repo: '${item['repo']}',
          icon: CupertinoIcons.archivebox,
          action: Container(),
          item: item,
        );
      },
    );
  }
}
