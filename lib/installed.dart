import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:watcher/watcher.dart';
import 'dart:io' as io;

class Installed extends StatefulWidget {
  final ScrollController? scrollController;
  const Installed({super.key, this.scrollController});

  @override
  _InstalledState createState() => _InstalledState();
}

class _InstalledState extends State<Installed> {
  var directory =
      '/Users/spacedevin/Library/Group Containers/UBF8T346G9.Office/Outlook/Outlook Sound Sets';

  List<FileSystemEntity> sets = [];

  @override
  void initState() {
    super.initState();
    updateFiles();

    // var watcher = DirectoryWatcher(p.absolute(directory));
    // watcher.events.listen((e) => updateFiles());
  }

  void updateFiles() {
    List<FileSystemEntity> files = [];
    print("Asd");

    io.Directory(directory).list().forEach((file) {
      // if (file is File) return;
      // if (!p.basename(file.path).contains('eragesoundset')) return;
      files.add(file);
    });

    setState(() {
      sets = files;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    sets.forEach((set) {
      var name = p.basename(set.path);

      list.add(
        Container(
          //width: MediaQuery.of(context).size.width / 3,
          color: Colors.red,
          child: Text(name),
        ),
      );
    });
    return LayoutBuilder(builder: (context, constraints) {
      return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1.5,
            crossAxisCount: constraints.maxWidth > 700 ? 3 : 2,
            mainAxisSpacing: 2,
          ),
          itemCount: sets.length,
          itemBuilder: (context, index) {
            return list[index];
          });
    });
  }
}
