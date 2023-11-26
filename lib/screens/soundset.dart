import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:soundset_market/widgets/duplicate.dart';
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
  final player = AudioPlayer();
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
      actions: [Duplicate()],
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
          PushButton(
            controlSize: ControlSize.regular,
            onPressed: () async {
              await player.play(DeviceFileSource(
                  path.join('${item['path']}/${item['plist']['SoundFile_NewMail']}')));
            },
            child: Text(
              item['plist']['SoundFile_NewMail'],
            ),
          ),
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
