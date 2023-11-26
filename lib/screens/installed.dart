import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as path;
import 'package:plist_parser/plist_parser.dart';
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

  @override
  void initState() {
    super.initState();
    updateFiles();

    var watcher = DirectoryWatcher(path.absolute(directory));
    watcher.events.listen((e) => updateFiles());
  }

  void updateFiles() {
    var files = [];

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
  }

  @override
  Widget build(BuildContext context) {
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
