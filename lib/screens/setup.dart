import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:system_theme/system_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        Text(
          'Changing your Outlook sounds its a two part process. First you need to download the soundset, then you need to install it. This guide will walk you through both steps.',
        ),
        PushButton(
          secondary: true,
          controlSize: ControlSize.large,
          onPressed: () => launchUrl(Uri.parse('ms-outlook://')),
          child: Text(
            'Open Outlook',
            style: TextStyle(
              color: SystemTheme.accentColor.accent,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        Text('Open Outlook'),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('2'),
            SizedBox(width: 20),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Go to Settings...'),
                  Image(
                    image: AssetImage(
                      'assets/images/outlook_menu.png',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Column(
          children: [
            Text('Select Notifications & Sounds'),
            Image(image: AssetImage('assets/images/outlook_settings.png')),
          ],
        ),
        Column(
          children: [
            Text('Select your sound set'),
            Image(image: AssetImage('assets/images/outlook_sounds.png')),
          ],
        ),
        Text('If your SoundSet is not appearing, try restarting Outlook'),
      ],
    );
  }
}
