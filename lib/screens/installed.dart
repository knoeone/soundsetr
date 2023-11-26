import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as path;
import 'package:plist_parser/plist_parser.dart';
import 'package:watcher/watcher.dart';
import 'dart:io' as io;

import '../utils/config.dart';
import '../utils/downloader.dart';
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

    Downloader.watchFiles().listen((files) {
      setState(() => sets = files);
    });
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
