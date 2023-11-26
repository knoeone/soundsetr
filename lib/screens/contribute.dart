import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:macos_ui/macos_ui.dart';

import '../utils/downloader.dart';
import '../widgets/md.dart';
import '../widgets/scaffold.dart';

class ContributeScreen extends StatelessWidget {
  const ContributeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldScreen(
      useSliver: true,
      children: [
        Container(
          color: MacosTheme.of(context).canvasColor,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Md(fetch: Downloader.contributing),
            ],
          ),
        ),
      ],
    );
  }
}
