import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:path/path.dart' as p;
import 'package:watcher/watcher.dart';
import 'dart:io' as io;

import '../widgets/download.dart';
import 'soundset.dart';

class MarketScreen extends StatefulWidget {
  final ScrollController? scrollController;
  const MarketScreen({super.key, this.scrollController});

  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  var filter = '';

  var sets = [
    {
      'name': 'l337-haxx0r/microsoft-soundset1',
      'repo': 'https://github.com/l337-haxx0r/microsoft-soundset',
      'description':
          'The soundset from Microsoft\'s Entourage 2004 for Mac, preserved for Outlook for Mac 2016, 2019, or 2021',
      'download':
          'https://raw.githubusercontent.com/l337-haxx0r/microsoft-soundset/main/Microsoft%20Sound%20Set.eragesoundset.zip',
    },
    {
      'name': 'l337-haxx0r/microsoft-soundset2',
      'repo': 'https://github.com/l337-haxx0r/microsoft-soundset',
      'description':
          'The soundset from Microsoft\'s Entourage 2004 for Mac, preserved for Outlook for Mac 2016, 2019, or 2021',
      'download':
          'https://raw.githubusercontent.com/l337-haxx0r/microsoft-soundset/main/Microsoft%20Sound%20Set.eragesoundset.zip',
    },
    {
      'name': 'l337-haxx0r/microsoft-soundset3',
      'repo': 'https://github.com/l337-haxx0r/microsoft-soundset',
      'description':
          'The soundset from Microsoft\'s Entourage 2004 for Mac, preserved for Outlook for Mac 2016, 2019, or 2021',
      'download':
          'https://raw.githubusercontent.com/l337-haxx0r/microsoft-soundset/main/Microsoft%20Sound%20Set.eragesoundset.zip',
    },
    {
      'name': 'l337-haxx0r/microsoft-soundset4',
      'repo': 'https://github.com/l337-haxx0r/microsoft-soundset',
      'description':
          'The soundset from Microsoft\'s Entourage 2004 for Mac, preserved for Outlook for Mac 2016, 2019, or 2021',
      'download':
          'https://raw.githubusercontent.com/l337-haxx0r/microsoft-soundset/main/Microsoft%20Sound%20Set.eragesoundset.zip',
    }
  ];

  @override
  void initState() {
    super.initState();
  }

  void setSearch(value) {
    setState(() {
      filter = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    for (var i = 0; i < sets.length; i++) {
      var name = sets[i]['name'];
      var description = sets[i]['description'];
      if (filter != '' && !name!.contains(filter) && !description!.contains(filter)) continue;

      list.add(
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MacosIcon(
                CupertinoIcons.archivebox,
                size: 30,
                color: MacosTheme.of(context).typography.headline.color,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(SoundsetScreen.route());
                        //Navigator.of(context).pushNamed('/soundset');
                      },
                      child: Text(
                        '$name',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '$description',
                      //overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        height: 1.4,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              DownloadButton(set: sets[i]),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Flexible(
          flex: 0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: MacosSearchField(
              padding: EdgeInsets.all(12),
              placeholder: 'Search for a sound set...',
              results: sets.map((e) => SearchResultItem(e['name'] as String)).toList(),
              onResultSelected: (resultItem) {
                debugPrint(resultItem.searchKey);
              },
              onChanged: (value) {
                setSearch(value);
              },
            ),
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return MasonryGridView.count(
                crossAxisCount: (constraints.maxWidth / 400).floor().clamp(1, 4),
                itemCount: list.length,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                itemBuilder: (context, index) {
                  return list[index];
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
