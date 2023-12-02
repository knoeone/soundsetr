import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:system_theme/system_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cross_file/cross_file.dart';

import '../models/soundset/soundset.dart';
import '../utils/downloader.dart';
import '../widgets/delete.dart';
import '../widgets/duplicate.dart';
import '../widgets/edit.dart';
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
  final SoundSet item;
  const SoundSetDetailScreen({super.key, required this.item});

  @override
  State<SoundSetDetailScreen> createState() => _SoundSetDetailScreenState();
}

class _SoundSetDetailScreenState extends State<SoundSetDetailScreen> {
  SoundSet? item;
  bool editing = false;
  var controllerName = TextEditingController();
  var controllerDescription = TextEditingController();
  var controllerRepository = TextEditingController();

  void loadItem() async {
    if (widget.item.path != null) {
      setState(() => item = widget.item);
    } else {
      await widget.item.cache();
      print(widget.item);

      setState(() => item = widget.item);
    }

    controllerName.text = item!.name;
    controllerDescription.text = item!.description;
    controllerRepository.text = item!.repo;
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
          widget.item.name,
          overflow: TextOverflow.ellipsis,
        ),
        child: const Center(
          child: ProgressCircle(),
        ),
      );
    }

    return ScaffoldScreen(
      canBack: true,
      title: editing
          ? MacosTextField(
              controller: controllerName,
              padding: const EdgeInsets.all(12.0),
              placeholder: 'asdasd',
            )
          : Text(
              '${item?.name}',
              overflow: TextOverflow.ellipsis,
            ),
      actions: [
        EditButton(
          item: item!,
          onEdit: () => setState(() => editing = !editing),
          onSave: () => EditButtonEdits(
            name: controllerName.text,
            description: controllerDescription.text,
            repository: controllerRepository.text,
          ),
          editing: editing,
        ),
        RevealButton(file: item!.path),
        PublishButton(item: item!),
        DuplicateButton(item: item!),
        DeleteButton(item: item!),
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
                  editing
                      ? MacosTextField(
                          controller: controllerDescription,
                          padding: const EdgeInsets.all(12.0),
                          placeholder: 'asdasd',
                        )
                      : Text('${item?.description}'),
                  const SizedBox(height: 10),
                  editing
                      ? MacosTextField(
                          controller: controllerRepository,
                          padding: const EdgeInsets.all(12.0),
                          placeholder: 'GitHub repo URL',
                        )
                      : GestureDetector(
                          onTap: () => launchUrl(Uri.parse('${item?.repo}')),
                          child: Text(
                            item!.repo,
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

class SoundSetAudioFile extends StatefulWidget {
  const SoundSetAudioFile({
    super.key,
    required this.item,
    required this.file,
  });

  final item;
  final String file;

  @override
  State<SoundSetAudioFile> createState() => _SoundSetAudioFileState();
}

class _SoundSetAudioFileState extends State<SoundSetAudioFile> {
  final List<XFile> _list = [];

  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (detail) {
        widget.item.replace(widget.file, detail.files[0]);
      },
      onDragEntered: (detail) {
        setState(() => _dragging = true);
      },
      onDragExited: (detail) {
        setState(() => _dragging = false);
      },
      child: Container(
        decoration: BoxDecoration(
          color: _dragging ? SystemTheme.accentColor.accent : Colors.transparent,
          border: Border.all(
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
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
                    '${audioNames[widget.file]}',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    audioDescriptions[widget.file] as String,
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
            widget.item.tmp == true
                ? SaveAudioButton(item: widget.item, file: widget.file)
                : ReplaceButton(item: widget.item, file: widget.file),
            PlayButton(
                item: widget.item, file: '${widget.item.path}/${widget.item.plist[widget.file]}')
          ],
        ),
      ),
    );
  }
}
