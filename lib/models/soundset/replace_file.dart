part of 'soundset.dart';

extension SoundSetReplace on SoundSet {
  replace(type, file) async {
    final Directory downloads = await getTemporaryDirectory();
    final tmpFile = p.join(downloads.path, plist![type]);
    final session = await FFmpegKit.execute('-y -i "${file.path}" "$tmpFile"');
    final returnCode = await session.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {
      // SUCCESS
    } else if (ReturnCode.isCancel(returnCode)) {
      // CANCEL
    } else {
      // ERROR
    }

    final destinationFile = p.join(SoundSet.createPathByName(name), plist![type]);

    if (File(destinationFile).existsSync()) {
      File(destinationFile).deleteSync();
    }

    if (!File(tmpFile).existsSync()) {
      return;
    }
    File(tmpFile).renameSync(destinationFile);

    final player = AudioPlayer();
    player.play(DeviceFileSource(destinationFile));
  }
}
