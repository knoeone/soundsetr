part of 'soundset.dart';

extension SoundSetPublish on SoundSet {
  Future publish() async {
    var appTempDir = 'soundsets';

    final Directory tempDir = await getTemporaryDirectory();
    var hash = sha1.convert(utf8.encode(name)).toString();

    var tmpDirName = p.join(tempDir.path, appTempDir, hash, '${name}.eragesoundset');

    try {
      await Directory(p.join(tempDir.path, appTempDir, hash)).delete(recursive: true);
    } catch (e) {
      print(e);
    }

    try {
      await Directory(tmpDirName).create(recursive: true);
    } catch (e) {
      print(e);
    }

    var files = [
      plist!['SoundFile_MailError'],
      plist!['SoundFile_MailSent'],
      plist!['SoundFile_NewMail'],
      plist!['SoundFile_NoMail'],
      plist!['SoundFile_Reminder'],
      plist!['SoundFile_Welcome'],
      plist!['ImageFile_Icon'],
      'soundset.plist',
      'README.md',
    ];

    void copyFile(assetFilePath) => File(
          p.join(
            path as String,
            assetFilePath,
          ),
        ).copySync(
          p.join(
            tmpDirName,
            assetFilePath,
          ),
        );

    for (var file in files) {
      try {
        copyFile(file);
      } catch (e) {
        print(e);
      }
    }

    return DownloaderSendResponse(
      files: files,
      path: p.join(tempDir.path, appTempDir, hash),
    );
  }
}
