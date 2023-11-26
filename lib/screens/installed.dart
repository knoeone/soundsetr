import 'package:flutter/cupertino.dart';
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
          icon: CupertinoIcons.archivebox,
          action: Container(),
          item: item,
        );
      },
    );
  }
}
