part of 'soundset.dart';

extension SoundSetGet on SoundSet {
  Future get() async {
    await cache();

    //final destinationDir = Directory(Config.path);
    final destinationFile = SoundSet.createSoundsetPathByName(name);

    copyPathSync(path as String, destinationFile);

    // its weird if it happens to fast so lets delay it so the user has some sort of visual feedback that isnt an ugly snack or toast
    return Future.delayed(const Duration(milliseconds: 1000));
  }
}
