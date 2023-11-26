import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:system_theme/system_theme.dart';

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
    if (!mounted || !context.mounted) return;
    setState(() => downloading = false);
  }

  @override
  Widget build(BuildContext context) {
    return PushButton(
      secondary: true,
      controlSize: ControlSize.large,
      onPressed: () => downlodSet(),
      child: downloading
          ? const ProgressCircle()
          : Text(
              'GET',
              style: TextStyle(color: SystemTheme.accentColor.accent, fontWeight: FontWeight.bold),
            ),
    );
  }
}
