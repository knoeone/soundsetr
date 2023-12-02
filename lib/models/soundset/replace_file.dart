import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:path_provider/path_provider.dart';

import 'soundset.dart';
import 'package:path/path.dart' as p;

mixin ReplaceFile on SoundSet {
  @override
  replace(name, file) async {
    final Directory downloads = await getTemporaryDirectory();
    final tmpFile = p.join(downloads.path, 'converted.aif');
    final session = await FFmpegKit.execute('-y -i "${file.path}" "$tmpFile"');
    final returnCode = await session.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {
      // SUCCESS
    } else if (ReturnCode.isCancel(returnCode)) {
      // CANCEL
    } else {
      // ERROR
    }

    final destinationFile = p.join(SoundSet.createSoundsetPathByName(name), plist![name]);

    File(destinationFile).deleteSync();
    File(tmpFile).renameSync(destinationFile);

    var player = AudioPlayer();
    player.play(DeviceFileSource(destinationFile));
  }
}
