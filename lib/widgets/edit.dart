import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import '../models/soundset.dart';
import '../utils/downloader.dart';

class EditButtonEdits {
  final String name;
  final String description;
  final String repository;

  EditButtonEdits({
    required this.name,
    required this.description,
    required this.repository,
  });
}

class EditButton extends StatelessWidget {
  final SoundSet item;
  final Function onEdit;
  final Function onSave;
  final bool editing;

  EditButton({
    super.key,
    required this.item,
    required this.editing,
    required this.onEdit,
    required this.onSave,
  });

  onEditPress(context) async {
    if (!editing) {
      onEdit();
      return;
    }

    EditButtonEdits edits = onSave();

    if (edits.name == '') {
      return;
    }

    item.name = edits.name;
    item.description = edits.description;
    item.repo = edits.repository;
    Downloader.saveSoundSet(item);
    onEdit();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: MacosTooltip(
        message: editing ? 'Save' : 'Edit',
        useMousePosition: false,
        child: MacosIconButton(
          icon: MacosIcon(
            editing ? CupertinoIcons.floppy_disk : CupertinoIcons.pencil_ellipsis_rectangle,
            color: MacosTheme.brightnessOf(context).resolve(
              const Color.fromRGBO(0, 0, 0, 0.5),
              const Color.fromRGBO(255, 255, 255, 0.5),
            ),
            size: 20.0,
          ),
          onPressed: () => onEditPress(context),
        ),
      ),
    );
  }
}
