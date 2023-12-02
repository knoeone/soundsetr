import 'dart:io';
import 'package:io/io.dart';
import 'soundset.dart';

mixin Duplicate on SoundSet {
  @override
  duplicate(name) {
    var dst = SoundSet.createSoundsetPathByName(name);

    if (Directory(dst).existsSync()) {
      dst.deleteSync(recursive: true);
    }

    copyPathSync(path as String, dst);
  }
}
