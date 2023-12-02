import 'dart:io';
import 'soundset.dart';

mixin Exists on SoundSet {
  @override
  exists() {
    return Directory(SoundSet.createSoundsetPathByName(name)).existsSync();
  }
}
