import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:path/path.dart' as p;
import 'package:watcher/watcher.dart';
import 'dart:io' as io;

class MarketScreen extends StatefulWidget {
  final ScrollController? scrollController;
  const MarketScreen({super.key, this.scrollController});

  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  var repo = 'https://api.github.com/repos/l337-haxx0r/microsoft-soundset/contents';

  var sets = [
    {
      'name': 'l337-haxx0r/microsoft-soundset1',
      'repo': 'https://github.com/l337-haxx0r/microsoft-soundset',
      'description':
          'The soundset from Microsoft\'s Entourage 2004 for Mac, preserved for Outlook for Mac 2016, 2019, or 2021',
    },
    {
      'name': 'l337-haxx0r/microsoft-soundset2',
      'repo': 'https://github.com/l337-haxx0r/microsoft-soundset',
      'description':
          'The soundset from Microsoft\'s Entourage 2004 for Mac, preserved for Outlook for Mac 2016, 2019, or 2021',
    },
    {
      'name': 'l337-haxx0r/microsoft-soundset3',
      'repo': 'https://github.com/l337-haxx0r/microsoft-soundset',
      'description':
          'The soundset from Microsoft\'s Entourage 2004 for Mac, preserved for Outlook for Mac 2016, 2019, or 2021',
    },
    {
      'name': 'l337-haxx0r/microsoft-soundset4',
      'repo': 'https://github.com/l337-haxx0r/microsoft-soundset',
      'description':
          'The soundset from Microsoft\'s Entourage 2004 for Mac, preserved for Outlook for Mac 2016, 2019, or 2021',
    }
  ];

  void downlodSet(set) {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    for (var i = 0; i < sets.length; i++) {
      var name = sets[i]['name'];
      var description = sets[i]['description'];

      list.add(
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MacosIcon(
                CupertinoIcons.archivebox,
                size: 30,
                color: MacosTheme.of(context).typography.headline.color,
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$name',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '$description',
                      //overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        height: 1.4,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              PushButton(
                secondary: true,
                child: Text('GET'),
                controlSize: ControlSize.large,
                onPressed: () {
                  downlodSet(sets[i]);
                },
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 0,
          child: MacosSearchField(
            placeholder: 'Search for a sound set...',
            results: sets.map((e) => SearchResultItem(e['name'] as String)).toList(),
            onResultSelected: (resultItem) {
              debugPrint(resultItem.searchKey);
            },
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1.7,
                  crossAxisCount: (constraints.maxWidth / 360).floor(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: sets.length,
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
