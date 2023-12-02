part of 'soundset.dart';

extension SoundSetDuplicate on SoundSet {
  duplicate(newName) {
    final dst = SoundSet.createPathByName(newName);

    if (Directory(dst).existsSync()) {
      dst.deleteSync(recursive: true);
    }

    copyPathSync(path as String, dst);
  }
}
