part of 'soundset.dart';

extension SoundSetExists on SoundSet {
  bool exists() {
    return name != ''
        ? Directory(
            SoundSet.createSoundsetPathByName(name),
          ).existsSync()
        : false;
  }
}
