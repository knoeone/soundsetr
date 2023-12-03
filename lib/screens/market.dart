import 'package:flutter/cupertino.dart';
import '../utils/downloader.dart';
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
  var sets = [];

  @override
  void initState() {
    super.initState();

    Downloader.watchNetwork().listen((files) {
      setState(() => sets = files);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Search(
      items: (filter) => sets
          .where(
            (item) =>
                filter == '' || (item.name).contains(filter) || (item.description).contains(filter),
          )
          .toList(),
      itemBuilder: (context, index, item) {
        return Card(
          title: '${item.name}',
          description: '${item.description}',
          repo: '${item.repo}',
          icon: CupertinoIcons.globe,
          image: item.icon != null ? Image.network(item.icon) : null,
          item: item,
          action: DownloadButton(
            item: item,
          ),
        );
      },
    );
  }
}
