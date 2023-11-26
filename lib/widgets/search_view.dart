import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:macos_ui/macos_ui.dart';

class SearchView extends StatefulWidget {
  final Function itemBuilder;
  final Function items;
  const SearchView({
    super.key,
    required this.items,
    required this.itemBuilder,
  });

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  var filter = '';

  void setSearch(value) {
    setState(() {
      filter = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    List filterd = widget.items(filter);

    return Column(
      children: [
        Flexible(
          flex: 0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: MacosSearchField(
              maxLines: 1,
              padding: const EdgeInsets.all(12),
              placeholder: 'Search for a sound set...',
              //results: sets.map((e) => SearchResultItem(e.path as String)).toList(),
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
                itemCount: filterd.length,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                itemBuilder: (context, index) => widget.itemBuilder(context, index, filterd[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
