import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
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

    var watcher = DirectoryWatcher(p.absolute(directory));
    watcher.events.listen((e) => updateFiles());
  }

  void updateFiles() {
    List<FileSystemEntity> files = [];

    io.Directory(directory).listSync().forEach((file) async {
      bool isFile = file is File;
      //bool isZip = isFile && p.basename(file.path).endsWith('.zip');
      var name = p.basename(file.path);
      //if (isFile && !isZip) return;
      if (isFile) return;
      if (!name.contains('eragesoundset')) return;
      files.add(file);
    });

    setState(() {
      sets = files..sort((a, b) => a.path.compareTo(b.path));
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    for (var i = 0; i < sets.length; i++) {
      var name = p.basename(sets[i].path).replaceAll('.eragesoundset', '');

      list.add(
        Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              const MacosIcon(
                CupertinoIcons.speaker_2_fill,
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const MacosIconButton(
                      icon: MacosIcon(
                        CupertinoIcons.star_fill,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1.7,
            crossAxisCount: (constraints.maxWidth / 280).floor(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemCount: sets.length,
          itemBuilder: (context, index) {
            return list[index];
          },
        );
      },
    );
  }
}
