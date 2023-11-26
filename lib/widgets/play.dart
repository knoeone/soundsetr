import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:watcher/watcher.dart';

import '../utils/downloader.dart';

class PlayButton extends StatefulWidget {
  final file;
  final item;
  const PlayButton({
    super.key,
    required this.file,
    required this.item,
  });

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  var player = AudioPlayer();
  var source;

  @override
  void initState() {
    super.initState();
    var watcher = DirectoryWatcher(widget.item['path']);
    watcher.events.listen((e) {
      player = AudioPlayer();
      if (!mounted) return;
      setSource();
    });
    setSource();
  }

  void setSource() {
    setState(() => source = DeviceFileSource(widget.file));
    player.setSource(source);
  }

  void playSound() {
    player.stop();
    player.play(source);
  }

  @override
  Widget build(BuildContext context) {
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
          onPressed: playSound,
        ),
      ),
    );
  }
}
