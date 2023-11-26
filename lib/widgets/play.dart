import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';

import '../utils/downloader.dart';

class PlayButton extends StatelessWidget {
  final file;
  PlayButton({super.key, required this.file});
  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    var source = DeviceFileSource(file);
    player.setSource(source);

    return SizedBox(
      height: 40,
      width: 40,
      child: MacosTooltip(
        message: 'Play',
        useMousePosition: false,
        child: MacosIconButton(
          icon: MacosIcon(
            CupertinoIcons.play,
            color: MacosTheme.of(context).primaryColor,
            size: 20.0,
          ),
          onPressed: () {
            player.stop();
            player.play(source);
          },
        ),
      ),
    );
  }
}
