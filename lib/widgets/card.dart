import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:soundset_market/screens/soundset.dart';
import 'package:system_theme/system_theme.dart';

class Card extends StatelessWidget {
  String title;
  String description;
  String repo;
  IconData icon;
  Widget? action;

  Card({
    super.key,
    required this.title,
    required this.repo,
    required this.description,
    required this.icon,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    var repoShort = repo.replaceAll('https://github.com/', '');
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MacosIcon(
            icon,
            size: 30,
            color: MacosTheme.of(context).typography.headline.color,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(SoundsetScreen.route());
                //Navigator.of(context).pushNamed('/soundset');
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    repoShort,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: SystemTheme.accentColor.accent,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      height: 1.4,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: action == null ? 0 : 10),
          action ?? const SizedBox(),
        ],
      ),
    );
  }
}
