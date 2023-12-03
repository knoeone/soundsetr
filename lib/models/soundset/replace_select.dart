part of 'soundset.dart';

extension SoundSetReplaceSelect on SoundSet {
  replaceSelect(type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['aif', 'wav', 'mp3', 'ogg', 'aiff', 'flac', 'm4a'],
    );

    if (result == null) return;
    File file = File(result.files.single.path!);

    return replace(type, file);
  }
}
