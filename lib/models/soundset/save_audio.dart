import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'soundset.dart';
import '../../utils/downloader.dart';

mixin SaveAudio on SoundSet {
  @override
  Future saveAudio(audioType) async {
    final Directory tempDir = await getDownloadsDirectory() as Directory;
    var tmpFileName = p.join(tempDir.path, '${name} - ${plist![audioType]}');
    var currentFile = File(p.join(path as String, plist![audioType]));

    currentFile.copySync(tmpFileName);
    Downloader.reveal(tempDir.path);
  }
}
