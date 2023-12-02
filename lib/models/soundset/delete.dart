part of 'soundset.dart';

extension SoundSetDelete on SoundSet {
  delete() {
    var dst = SoundSet.createSoundsetPathByName(name);

    Directory(dst).deleteSync(recursive: true);
  }
}
