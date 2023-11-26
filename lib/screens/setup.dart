import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:system_theme/system_theme.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/scaffold.dart';

class SetupScreen extends StatelessWidget {
  final goToIndex;
  const SetupScreen({super.key, this.goToIndex});

  @override
  Widget build(BuildContext context) {
    return ScaffoldScreen(
      useSliver: true,
      title: const Text(
        'Get Started',
        maxLines: 1,
      ),
      children: [
        Container(
          color: MacosTheme.of(context).canvasColor,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Changing your Outlook sounds its a two part process. First you need to download the soundset, then you need to install it. This guide will walk you through both steps.',
                style: TextStyle(
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 26),
              Divider(thickness: 1, color: MacosTheme.of(context).dividerColor),
              const SizedBox(height: 26),
              const Text(
                'When downloading a SoundSet, it will automaticly be created in your Outlook SoundSet Directory.',
                style: TextStyle(
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 26),
              SetupItem(
                num: 1,
                text: 'Go to the Store on the left hand menu.\n',
                extra: PushButton(
                  secondary: true,
                  controlSize: ControlSize.large,
                  onPressed: () => goToIndex(2),
                  child: Text(
                    'Open Store',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 26),
              SetupItem(
                num: 2,
                text: 'Select any pack you want and click "GET".\n',
              ),
              const SizedBox(height: 26),
              Divider(thickness: 1, color: MacosTheme.of(context).dividerColor),
              const SizedBox(height: 26),
              const Text(
                'Once you have a SoundSet downloaded, you will need to change the SoundSet in Outlook.',
                style: TextStyle(
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 26),
              SetupItem(
                num: 1,
                text: 'Open the Outlook desktop app on the Mac you want to change the sounds on.\n',
                extra: PushButton(
                  secondary: true,
                  controlSize: ControlSize.large,
                  onPressed: () => launchUrl(Uri.parse('ms-outlook://')),
                  child: Text(
                    'Open Outlook',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 26),
              const SetupItem(
                num: 2,
                text: 'From the top meny bar, Click "Outlook" and select "Settings..."\n',
                image: 'outlook_menu',
              ),
              const SizedBox(height: 26),
              const SetupItem(
                num: 3,
                text: 'Select Notifications & Sounds',
                image: 'outlook_settings',
              ),
              const SizedBox(height: 26),
              const SetupItem(
                num: 4,
                text: 'Click the currently enabled SoundSet and select the set you want to use.',
                image: 'outlook_sounds',
              ),
              const SizedBox(height: 26),
              const Text('If your SoundSet is not appearing, try restarting Outlook'),
            ],
          ),
        ),
      ],
    );
  }
}

class SetupItem extends StatelessWidget {
  final int num;
  final String text;
  final String? image;
  final Widget? extra;
  const SetupItem({
    super.key,
    required this.num,
    this.image,
    required this.text,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$num.',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 20),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                //style: MacosTheme.of(context).typography.title2,
              ),
              image != null
                  ? ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 700),
                      child: Image(
                        image: AssetImage(
                          'assets/images/$image.png',
                        ),
                      ),
                    )
                  : extra ?? const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
