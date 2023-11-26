import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:system_theme/system_theme.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/downloader.dart';

class Md extends StatefulWidget {
  final fetch;
  const Md({super.key, this.fetch});

  @override
  State<Md> createState() => _MdState();
}

class _MdState extends State<Md> {
  String? md;
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    String response = await widget.fetch();
    print(response);
    setState(() {
      md = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (md == null) {
      return const Center(child: ProgressCircle());
    }
    var textColor = MacosTheme.brightnessOf(context).resolve(
      const Color.fromRGBO(0, 0, 0, 1),
      const Color.fromRGBO(255, 255, 255, 1),
    );

    return MarkdownBody(
      softLineBreak: true,
      data: md as String,
      onTapLink: (text, url, title) {
        launchUrl(Uri.parse(url as String));
      },
      imageBuilder: (url, text, title) {
        if (text == 'jumbo') {
          return const SizedBox();
        }
        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Image.network(url.toString()),
        );
      },
      styleSheet: MarkdownStyleSheet.fromCupertinoTheme(CupertinoTheme.of(context)).copyWith(
        h1: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        h1Padding: const EdgeInsets.only(bottom: 8.0, top: 12),
        h2: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        h2Padding: const EdgeInsets.only(bottom: 8.0, top: 12),
        h3: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        h3Padding: const EdgeInsets.only(bottom: 8.0, top: 12),
        h4: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: textColor,
          letterSpacing: 0,
        ),
        h5: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: textColor,
          letterSpacing: 0,
        ),
        h6: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textColor,
          letterSpacing: 0,
        ),
        p: TextStyle(
          fontSize: 14,
          color: textColor,
          letterSpacing: 0,
          height: 1.7,
        ),
        strong: TextStyle(
          fontSize: 14,
          color: textColor,
          letterSpacing: 0,
        ),
        a: TextStyle(
          color: SystemTheme.accentColor.accent,
        ),
        blockquote: const TextStyle(
          fontSize: 14,
          fontStyle: FontStyle.italic,
        ),
        blockquoteDecoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: MacosTheme.brightnessOf(context).resolve(
                const Color.fromRGBO(0, 0, 0, 0.15),
                const Color.fromRGBO(255, 255, 255, 0.15),
              ),
              width: 4,
            ),
          ),
        ),
        code: TextStyle(
          backgroundColor: Colors.transparent,
          fontSize: 14,
          fontFamily: 'Courier',
          color: MacosTheme.brightnessOf(context).resolve(
            const Color.fromRGBO(0, 0, 0, 1),
            const Color.fromRGBO(255, 255, 255, 1),
          ),
        ),
        codeblockPadding: const EdgeInsets.all(8),
        codeblockDecoration: BoxDecoration(
          color: MacosTheme.brightnessOf(context).resolve(
            const Color.fromRGBO(0, 0, 0, 0.05),
            const Color.fromRGBO(255, 255, 255, 0.05),
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        blockSpacing: 14,
        horizontalRuleDecoration: BoxDecoration(
          gradient:
              LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
            Colors.transparent,
            MacosTheme.brightnessOf(context).resolve(
              const Color.fromRGBO(0, 0, 0, 0.15),
              const Color.fromRGBO(255, 255, 255, 0.15),
            ),
            Colors.transparent,
          ], stops: [
            0.499,
            0.5,
            0.599,
          ]),
          border: Border(
            top: BorderSide(
              width: 10,
              color: Colors.transparent,
            ),
            bottom: BorderSide(
              color: Colors.transparent,
              width: 10,
            ),
          ),
        ),
        // blockquotePadding: const EdgeInsets.only(left: 16.0),
        listBulletPadding: const EdgeInsets.only(right: 16),
        listBullet: TextStyle(
          fontSize: 14,
          color: textColor,
          letterSpacing: 0,
        ),
        listIndent: 20,
      ),
    );
  }
}
