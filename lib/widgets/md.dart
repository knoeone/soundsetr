import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:macos_ui/macos_ui.dart';

import '../utils/downloader.dart';

class Md extends StatefulWidget {
  final fetch;
  const Md({super.key, this.fetch});

  @override
  State<Md> createState() => _MdState();
}

class _MdState extends State<Md> {
  String? md;
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    String response = await widget.fetch();
    print(response);
    setState(() {
      md = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (md == null) {
      return const Center(child: ProgressCircle());
    }
    return Markdown(
      data: md as String,
      styleSheet: MarkdownStyleSheet.fromCupertinoTheme(CupertinoTheme.of(context)),
    );
  }
}
