part of 'soundset.dart';

getSoundSetPlist(path) {
  File file = File(p.join(path as String, 'soundset.plist'));
  String plist = file.readAsStringSync();
  var list = PropertyListSerialization.propertyListWithString(plist);
  return list;
}

extension SoundSetPlist on SoundSet {
  savePlist() async {
    final soundsetFile = p.join(path as String, 'soundset.plist');

    File file = File(soundsetFile);
    String plist = await file.readAsString();

    var dict = PropertyListSerialization.propertyListWithString(plist) as Map;
    dict['SoundSetUserString'] = description;
    dict['SoundSetURL'] = repo;
    dict['SoundSetDownloadURL'] = '${download}';

    var result = PropertyListSerialization.stringWithPropertyList(dict);

    File(soundsetFile).writeAsStringSync(result);
  }
}
