part of 'soundset.dart';

extension SoundSetReplaceSelect on SoundSet {
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
