import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/config.dart';

class SettingsScreen extends StatelessWidget {
  final ScrollController? scrollController;
  const SettingsScreen({super.key, this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MacosTextField(
          padding: const EdgeInsets.all(12.0),
          placeholder: 'Type some text here',
        ),
        PushButton(
          secondary: true,
          controlSize: ControlSize.large,
          onPressed: () => launchUrl(Uri.parse('file://${Config.path}')),
          child: Text(
            'Open Path',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
