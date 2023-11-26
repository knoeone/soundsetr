import 'package:flutter/cupertino.dart';
import '../widgets/card.dart';
import '../widgets/download.dart';
import '../widgets/search.dart';

class MarketScreen extends StatefulWidget {
  final ScrollController? scrollController;
  const MarketScreen({super.key, this.scrollController});

  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  var sets = [
    {
      'name': 'Microsoft Sound Set',
      'repo': 'https://github.com/l337-haxx0r/microsoft-soundset',
      'description':
          'The soundset from Microsoft\'s Entourage 2004 for Mac, preserved for Outlook for Mac 2016, 2019, or 2021',
      'download':
          'https://raw.githubusercontent.com/l337-haxx0r/microsoft-soundset/main/Microsoft%20Sound%20Set.eragesoundset.zip',
    },
    {
      'name': 'Microsoft Sound Set',
      'repo': 'https://github.com/l337-haxx0r/microsoft-soundset',
      'description':
          'The soundset from Microsoft\'s Entourage 2004 for Mac, preserved for Outlook for Mac 2016, 2019, or 2021',
      'download':
          'https://raw.githubusercontent.com/l337-haxx0r/microsoft-soundset/main/Microsoft%20Sound%20Set.eragesoundset.zip',
    },
    {
      'name': 'Microsoft Sound Set',
      'repo': 'https://github.com/l337-haxx0r/microsoft-soundset',
      'description':
          'The soundset from Microsoft\'s Entourage 2004 for Mac, preserved for Outlook for Mac 2016, 2019, or 2021',
      'download':
          'https://raw.githubusercontent.com/l337-haxx0r/microsoft-soundset/main/Microsoft%20Sound%20Set.eragesoundset.zip',
    },
    {
      'name': 'Microsoft Sound Set',
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
          item: item,
          action: DownloadButton(
            item: item,
          ),
        );
      },
    );
  }
}
