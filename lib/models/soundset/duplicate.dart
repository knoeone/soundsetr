part of 'soundset.dart';

extension SoundSetDuplicate on SoundSet {
  duplicate(name) {
    var dst = SoundSet.createSoundsetPathByName(name);

    if (Directory(dst).existsSync()) {
      dst.deleteSync(recursive: true);
    }

    copyPathSync(path as String, dst);
  }
}
