import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import '../utils/downloader.dart';
import '../widgets/md.dart';
import '../widgets/scaffold.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldScreen(
      useSliver: true,
      children: [
        Image.network(
          'https://raw.githubusercontent.com/knoeone/soundsetr/main/res/home.jpg',
        ),
        Container(
          color: MacosTheme.of(context).canvasColor,
          padding: const EdgeInsets.all(20),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Md(fetch: Downloader.readmeMd),
            ],
          ),
        ),
      ],
    );
  }
}
