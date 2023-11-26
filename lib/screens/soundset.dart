import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:system_theme/system_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/downloader.dart';
import '../widgets/delete.dart';
import '../widgets/duplicate.dart';
import '../widgets/play.dart';
import '../widgets/publish.dart';
import '../widgets/replace.dart';
import '../widgets/reveal.dart';
import '../widgets/save.dart';
import '../widgets/scaffold.dart';

const audioDescriptions = {
  'SoundFile_NewMail': 'Played when receiving new mails.',
  'SoundFile_MailError': 'Played when mail fails to sync, or you are offline.',
  'SoundFile_MailSent': 'Played when an email has just been sent.',
  'SoundFile_NoMail': 'Played when you have no friends.',
  'SoundFile_Reminder': 'Played when a meeting with an event reminder happens.',
  'SoundFile_Welcome': 'Played when Outlook first opens.',
};

const audioNames = {
  'SoundFile_NewMail': 'New Mail',
  'SoundFile_MailError': 'Mail Error',
  'SoundFile_MailSent': 'Mail Sent',
  'SoundFile_NoMail': 'No Mail',
  'SoundFile_Reminder': 'Reminder',
  'SoundFile_Welcome': 'Welcome',
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

class SoundSetDetailScreen extends StatefulWidget {
  final item;
  const SoundSetDetailScreen({super.key, required this.item});

  @override
  State<SoundSetDetailScreen> createState() => _SoundSetDetailScreenState();
}

class _SoundSetDetailScreenState extends State<SoundSetDetailScreen> {
  var item;

  void loadItem() async {
    if (widget.item['path'] != null) {
      setState(() => item = widget.item);
    } else {
      var updatedItem = await Downloader.preview(widget.item);
      print(updatedItem);

      setState(() => item = updatedItem);
    }
  }

  @override
  void initState() {
    super.initState();
    loadItem();
  }

  @override
  Widget build(BuildContext context) {
    if (item == null) {
      return ScaffoldScreen(
        canBack: true,
        title: Text(
          widget.item['name'],
          overflow: TextOverflow.ellipsis,
        ),
        child: const Center(
          child: ProgressCircle(),
        ),
      );
    }

    return ScaffoldScreen(
      canBack: true,
      title: Text(
        item['name'],
        overflow: TextOverflow.ellipsis,
      ),
      actions: [
        RevealButton(file: item['path']),
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
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => launchUrl(Uri.parse(item['repo'])),
                    child: Text(
                      item['repo'],
                      style: TextStyle(
                        fontSize: 13,
                        color: SystemTheme.accentColor.accent,
                        //decoration: TextDecoration.underline,
                      ),
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
  const SoundSetAudioFile({
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
                  '${audioNames[file]}',
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
          item['tmp'] == true
              ? SaveAudioButton(item: item, file: file)
              : ReplaceButton(item: item, file: file),
          PlayButton(item: item, file: '${item['path']}/${item['plist'][file]}')
        ],
      ),
    );
  }
}
