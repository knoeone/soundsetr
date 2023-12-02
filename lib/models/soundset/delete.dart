import 'dart:io';
import 'soundset.dart';

mixin Delete on SoundSet {
  @override
  delete() {
    var dst = SoundSet.createSoundsetPathByName(name);

    Directory(dst).deleteSync(recursive: true);
  }
}
