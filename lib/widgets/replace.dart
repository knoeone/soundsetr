import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:system_theme/system_theme.dart';

import '../models/soundset.dart';
import '../utils/downloader.dart';

class ReplaceButton extends StatelessWidget {
  final file;
  final SoundSet item;
  const ReplaceButton({
    super.key,
    required this.file,
    required this.item,
  });

  void replaceFile() async {
    print('file $file');
    await Downloader.replaceSelect(item, file);
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
            CupertinoIcons.doc,
            color: SystemTheme.accentColor.accent,
            size: 20.0,
          ),
          onPressed: replaceFile,
        ),
      ),
    );
  }
}
