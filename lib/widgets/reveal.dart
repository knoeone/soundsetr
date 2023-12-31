import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

import '../utils/downloader.dart';

class RevealButton extends StatelessWidget {
  final file;
  const RevealButton({super.key, required this.file});

  void onReveal() {
    Downloader.reveal(file);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: MacosTooltip(
        message: 'Show in Finder',
        useMousePosition: false,
        child: MacosIconButton(
          icon: MacosIcon(
            CupertinoIcons.folder,
            color: MacosTheme.brightnessOf(context).resolve(
              const Color.fromRGBO(0, 0, 0, 0.5),
              const Color.fromRGBO(255, 255, 255, 0.5),
            ),
            size: 20.0,
          ),
          onPressed: onReveal,
        ),
      ),
    );
  }
}
