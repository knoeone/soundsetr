part of 'soundset.dart';

extension SoundSetDelete on SoundSet {
  delete() {
    final dst = SoundSet.createPathByName(name);

    Directory(dst).deleteSync(recursive: true);
  }
}
