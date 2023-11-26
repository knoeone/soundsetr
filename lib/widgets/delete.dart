import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

import '../models/soundset.dart';
import '../utils/downloader.dart';

class DeleteButton extends StatelessWidget {
  final SoundSet item;
  const DeleteButton({super.key, required this.item});

  duplicateSet(context) async {
    void onComplete() {
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).pop();
      Downloader.delete(item);
    }

    showMacosAlertDialog(
      context: context,
      builder: (_) => MacosAlertDialog(
        appIcon: Container(
          height: 1,
        ),
        title: Text(
          'Delete SoundSet',
          style: MacosTheme.of(context).typography.headline,
        ),
        message: Text(
          'Are you sure you want to delete this SoundSet?',
          textAlign: TextAlign.center,
          style: MacosTypography.of(context).body,
        ),
        primaryButton: PushButton(
          controlSize: ControlSize.large,
          child: const Text('OK'),
          onPressed: () => onComplete(),
        ),
        secondaryButton: PushButton(
          secondary: true,
          controlSize: ControlSize.large,
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: MacosTooltip(
        message: 'Delete',
        useMousePosition: false,
        child: MacosIconButton(
          icon: MacosIcon(
            CupertinoIcons.trash,
            color: MacosTheme.brightnessOf(context).resolve(
              const Color.fromRGBO(0, 0, 0, 0.5),
              const Color.fromRGBO(255, 255, 255, 0.5),
            ),
            size: 20.0,
          ),
          onPressed: () => duplicateSet(context),
        ),
      ),
    );
  }
}
