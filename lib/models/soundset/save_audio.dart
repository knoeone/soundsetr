part of 'soundset.dart';

extension SoundSetSaveAudio on SoundSet {
  Future saveAudio(audioType) async {
    final Directory tempDir = await getDownloadsDirectory() as Directory;
    var tmpFileName = p.join(tempDir.path, '${name} - ${plist![audioType]}');
    var currentFile = File(p.join(path as String, plist![audioType]));

    currentFile.copySync(tmpFileName);
    Downloader.reveal(tempDir.path);
  }
}
