import 'dart:io';
import 'package:io/io.dart';
import 'path.dart';
import 'soundset.dart';
import 'package:path/path.dart' as p;

mixin Get on SoundSet {
  @override
  Future get() async {
    final tmpSet = await cache();

    //final destinationDir = Directory(Config.path);
    final destinationFile = SoundSet.createSoundsetPathByName(name);

    copyPathSync(tmpSet.path as String, destinationFile);

    // its weird if it happens to fast so lets delay it so the user has some sort of visual feedback that isnt an ugly snack or toast
    return Future.delayed(const Duration(milliseconds: 2000), () {});
  }
}
