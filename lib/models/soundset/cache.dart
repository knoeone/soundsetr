part of 'soundset.dart';

extension SoundSetCache on SoundSet {
  Future cache() async {
    var appTempDir = 'soundsets';
    final Directory tempDir = await getTemporaryDirectory();
    var name = sha1.convert(utf8.encode(download as String)).toString();
    var tmpFileName = p.join(tempDir.path, appTempDir, '$name.zip');
    var tmpFile = File(tmpFileName);
    var tmpDirName = p.join(tempDir.path, appTempDir, name);

    try {
      await Directory(p.join(tempDir.path, appTempDir)).create();
    } catch (e) {
      print(e);
    }

    final request = await HttpClient().getUrl(Uri.parse(download as String));
    final response = await request.close();
    await response.pipe(tmpFile.openWrite());

    try {
      await ZipFile.extractToDirectory(zipFile: tmpFile, destinationDir: Directory(tmpDirName));
    } catch (e) {
      print(e);
    }
    try {
      tmpFile.deleteSync();
    } catch (e) {
      print(e);
    }

    var extractedDir = Directory(tmpDirName).listSync().firstWhere(
          (file) => p.basename(file.path).endsWith('.eragesoundset'),
        );
    print(extractedDir);

    path = extractedDir.path;
    tmp = true;
  }
}
