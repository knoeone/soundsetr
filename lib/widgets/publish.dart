import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

import '../models/soundset.dart';
import '../utils/publish.dart';

class PublishButton extends StatelessWidget {
  final SoundSet item;
  const PublishButton({super.key, required this.item});

  publishSet(context) async {
    Publish.publishSet(item);
    return;
    void onComplete() {
      Navigator.of(context, rootNavigator: true).pop();
    }

    showMacosAlertDialog(
      context: context,
      builder: (_) => MacosAlertDialog(
        appIcon: Container(
          height: 1,
        ),
        title: Text(
          'Publish SoundSet',
          style: MacosTheme.of(context).typography.headline,
        ),
        message: Text(
          'Coming soon...',
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
        message: 'Publish',
        useMousePosition: false,
        child: MacosIconButton(
          icon: MacosIcon(
            CupertinoIcons.share_up,
            color: MacosTheme.brightnessOf(context).resolve(
              const Color.fromRGBO(0, 0, 0, 0.5),
              const Color.fromRGBO(255, 255, 255, 0.5),
            ),
            size: 20.0,
          ),
          onPressed: () => publishSet(context),
        ),
      ),
    );
  }
}
