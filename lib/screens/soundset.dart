import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:soundset_market/widgets/duplicate.dart';
import '../utils/downloader.dart';
import '../widgets/delete.dart';
import '../widgets/publish.dart';
import '../widgets/reveal.dart';
import '../widgets/scaffold.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path/path.dart' as path;

class SoundsetScreen extends StatelessWidget {
  final ScrollController? scrollController;
  const SoundsetScreen({super.key, this.scrollController});

  static Route<dynamic> route({required item}) {
    return CupertinoPageRoute(
      builder: (BuildContext context) {
        return SoundSetDetailScreen(item: item);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SoundSetDetailScreen extends StatelessWidget {
  final item;
  SoundSetDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
//    return Container(width: 100, height: 100, color: Colors.red);

    // ...
    return ScaffoldScreen(
      canBack: true,
      title: Text(item['name']),
      // actions: [
      //   ToolBarIconButton(
      //     label: "Duplicate SoundSet",
      //     icon: const MacosIcon(
      //       CupertinoIcons.doc_on_clipboard,
      //     ),
      //     onPressed: () => MacosWindowScope.of(context).toggleSidebar(),
      //     showLabel: false,
      //   ),
      // ],
      actions: [
        RevealButton(item: item),
        PublishButton(item: item),
        DuplicateButton(item: item),
        DeleteButton(item: item),
      ],
      child: Column(
        children: [
          Text(item['description']),
          Text(item['repo']),
          Text(
            item['plist']['SoundFile_MailError'],
          ),
          Text(
            item['plist']['SoundFile_MailSent'],
          ),
          SoundSetAudioFile(item: item, file: 'SoundFile_NewMail'),
          Text(
            item['plist']['SoundFile_NoMail'],
          ),
          Text(
            item['plist']['SoundFile_Reminder'],
          ),
          Text(
            item['plist']['SoundFile_Welcome'],
          ),
        ],
      ),
    );
  }
}

class SoundSetAudioFile extends StatelessWidget {
  SoundSetAudioFile({
    super.key,
    required this.item,
    required this.file,
  });

  final item;
  final String file;
  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          item['plist'][file].replaceAll('.aif', ''),
        ),
        MacosIconButton(
          icon: MacosIcon(
            CupertinoIcons.play,
            color: MacosTheme.of(context).primaryColor,
            size: 20.0,
          ),
          onPressed: () {
            player.stop();
            player.play(
              DeviceFileSource(
                path.join('${item['path']}/${item['plist'][file]}'),
              ),
            );
          },
        ),
      ],
    );
  }
}
