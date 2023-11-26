import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:system_theme/system_theme.dart';

import '../utils/downloader.dart';

class SaveAudioButton extends StatelessWidget {
  final item;
  final file;
  const SaveAudioButton({super.key, this.item, this.file});

  void saveAudio() {
    Downloader.saveAudio(item, file);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: MacosTooltip(
        message: 'Replace File',
        useMousePosition: false,
        child: MacosIconButton(
          icon: MacosIcon(
            CupertinoIcons.arrow_down_doc,
            color: MacosTheme.of(context).primaryColor,
            size: 20.0,
          ),
          onPressed: saveAudio,
        ),
      ),
    );
  }
}
