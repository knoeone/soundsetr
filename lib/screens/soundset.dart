import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:siri_wave/siri_wave.dart';
import 'package:soundset_market/widgets/duplicate.dart';
import '../widgets/delete.dart';
import '../widgets/play.dart';
import '../widgets/publish.dart';
import '../widgets/replace.dart';
import '../widgets/reveal.dart';
import '../widgets/scaffold.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path/path.dart' as path;

const audioDescriptions = {
  'SoundFile_NewMail': 'Played when receiving new mails.',
  'SoundFile_MailError': 'Played when mail fails to sync, or you are offline.',
  'SoundFile_MailSent': 'Played when an email has just been sent.',
  'SoundFile_NoMail': 'Played when you have no friends.',
  'SoundFile_Reminder': 'Played when a meeting with an event reminder happens.',
  'SoundFile_Welcome': 'Played when Outlook first opens.',
};

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
    return ScaffoldScreen(
      canBack: true,
      title: Text(item['name']),
      actions: [
        RevealButton(item: item),
        PublishButton(item: item),
        DuplicateButton(item: item),
        DeleteButton(item: item),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 0,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['description']),
                  SizedBox(height: 10),
                  Text(
                    item['repo'],
                    style: TextStyle(
                      fontSize: 13,
                      color: MacosTheme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return MasonryGridView.count(
                  crossAxisCount: (constraints.maxWidth / 400).floor().clamp(1, 4),
                  itemCount: audioDescriptions.length,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  itemBuilder: (context, index) => SoundSetAudioFile(
                    item: item,
                    file: audioDescriptions.entries.elementAt(index).key,
                  ),
                );
              },
            ),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MacosIcon(
            CupertinoIcons.speaker_2,
            size: 30,
            color: MacosTheme.of(context).typography.headline.color,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['plist'][file].replaceAll('.aif', ''),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  audioDescriptions[file] as String,
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
          const SizedBox(width: 20),
          ReplaceButton(item: item, file: file, onChange: () => {}),
          PlayButton(item: item, file: '${item['path']}/${item['plist'][file]}')
        ],
      ),
    );
  }
}
