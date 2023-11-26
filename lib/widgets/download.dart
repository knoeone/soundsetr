import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:path/path.dart' as p;
import 'package:system_theme/system_theme.dart';
import 'package:watcher/watcher.dart';
import 'dart:io' as io;

import '../utils/downloader.dart';

class DownloadButton extends StatefulWidget {
  final set;
  const DownloadButton({super.key, this.set});

  @override
  _DownloadButtonState createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  bool downloading = false;

  Future downlodSet() async {
    if (downloading) return;

    setState(() => downloading = true);
    await Downloader.get(widget.set);
    setState(() => downloading = false);
  }

  @override
  Widget build(BuildContext context) {
    return PushButton(
      secondary: true,
      controlSize: ControlSize.large,
      onPressed: () => downlodSet(),
      child: downloading
          ? ProgressCircle()
          : Text('GET',
              style: TextStyle(color: SystemTheme.accentColor.accent, fontWeight: FontWeight.bold)),
    );
  }
}
