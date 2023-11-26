import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:system_theme/system_theme.dart';

import '../utils/downloader.dart';

class DownloadButton extends StatefulWidget {
  final item;
  const DownloadButton({super.key, this.item});

  @override
  _DownloadButtonState createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  bool downloading = false;

  Future downlodSet(context) async {
    if (downloading) return;

    setState(() => downloading = true);

    if (Downloader.exists(widget.item)) {
      showMacosAlertDialog(
        context: context,
        builder: (_) => MacosAlertDialog(
          appIcon: Container(),
          title: Text(
            'Replace SoundSet',
            style: MacosTheme.of(context).typography.headline,
          ),
          message: Text(
            'A SoundSet named "${widget.item['name']}" already exists. Do you want to replace it?',
            textAlign: TextAlign.center,
            style: MacosTypography.of(context).body,
          ),
          primaryButton: PushButton(
            controlSize: ControlSize.large,
            child: Text('Yes'),
            onPressed: () {
              downlodSetConfirmed(confirmed: true);
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          secondaryButton: PushButton(
            secondary: true,
            controlSize: ControlSize.large,
            child: Text('No'),
            onPressed: () {
              //Navigator.of(context).pop();
              downlodSetConfirmed(confirmed: false);
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ),
      );
    } else {
      downlodSetConfirmed(confirmed: true);
    }
  }

  Future downlodSetConfirmed({confirmed = false}) async {
    if (confirmed) {
      await Downloader.get(widget.item);
    }
    if (!mounted || !context.mounted) return;
    setState(() => downloading = false);
  }

  // @override
  // void setState(VoidCallback fn) {
  //   if (!mounted) {
  //     return;
  //   }

  //   super.setState(fn);
  // }

  @override
  Widget build(BuildContext context) {
    return PushButton(
      secondary: true,
      controlSize: ControlSize.large,
      onPressed: () => downlodSet(context),
      child: downloading
          ? const ProgressCircle()
          : Text(
              'GET',
              style: TextStyle(color: SystemTheme.accentColor.accent, fontWeight: FontWeight.bold),
            ),
    );
  }
}
