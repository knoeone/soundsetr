import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';

import '../utils/downloader.dart';

class ReplaceButton extends StatelessWidget {
  final file;
  final item;
  ReplaceButton({
    super.key,
    required this.file,
    required this.item,
  });

  void replaceFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['aif', 'wav', 'mp3']);

    if (result != null) {
      File file = File(result.files.single.path!);
    } else {
      // User canceled the picker
    }
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
            color: MacosTheme.of(context).primaryColor,
            size: 20.0,
          ),
          onPressed: replaceFile,
        ),
      ),
    );
  }
}
