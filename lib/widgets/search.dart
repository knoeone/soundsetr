import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:macos_ui/macos_ui.dart';

class Search extends StatefulWidget {
  final Function itemBuilder;
  final Function items;
  const Search({
    super.key,
    required this.items,
    required this.itemBuilder,
  });

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var filter = '';
  var controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List filterd = widget.items(filter);
    List all = widget.items('');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: MacosSearchField(
              controller: controller,
              maxLines: 1,
              padding: const EdgeInsets.all(12),
              placeholder: 'Search for a SoundSet...',
              results: all.map((e) => SearchResultItem(e['name'] as String)).toList(),
              onResultSelected: (resultItem) {
                debugPrint(resultItem.searchKey);
              },
            ),
          ),
        ),
        Expanded(
          child: filterd.length > 0
              ? LayoutBuilder(
                  builder: (context, constraints) {
                    return MasonryGridView.count(
                      crossAxisCount: (constraints.maxWidth / 400).floor().clamp(1, 4),
                      itemCount: filterd.length,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      itemBuilder: (context, index) =>
                          widget.itemBuilder(context, index, filterd[index]),
                    );
                  },
                )
              : Padding(
                  padding: EdgeInsets.only(top: 20, left: 20),
                  child: Text('No results found'),
                ),
        ),
      ],
    );
  }
}
