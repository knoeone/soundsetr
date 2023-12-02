import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'soundset.dart';

mixin Duplicate on SoundSet {
  @override
  replaceSelect(name) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['aif', 'wav', 'mp3', 'ogg', 'aiff', 'flac', 'm4a'],
    );

    // final _macosFilePickerPlugin = MacosFilePicker();

    // final result =
    //     await _macosFilePickerPlugin.pick(MacosFilePickerMode.fileAndFolder, allowsMultiple: false);

    if (result == null) return;
    File file = File(result.files.single.path!);

    return replace(name, file);
  }
}
