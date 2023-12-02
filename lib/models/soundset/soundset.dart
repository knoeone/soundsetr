import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:propertylistserialization/propertylistserialization.dart';
import 'create_new.dart';
import 'path.dart';
import 'soundset_type.dart';

class SoundSet with CreateNew, Path {
  static createSoundsetPathByName(name) => {};
  static createNew(name) => {};
  saveAudio(type) => {};
  duplicate(name) => {};
  cache() => {};
  exists() => {};
  delete() => {};
  get() => {};
  replace(type, file) => {};
  replaceSelect(type) => {};

  String name;
  String description;
  String repo;
  String? download;
  // path = Config.path / name.eragesoundset for installed soundsets
  String? path;
  Map? _plist;
  bool tmp;

  SoundSet({
    required this.name,
    required this.description,
    required this.repo,
    this.download,
    this.path,
    this.tmp = false,
  });

  Map? get plist {
    if (path == null) return null;
    _plist ??= getPlist(path as String);
    return _plist as Map;
  }

  set plist(Map? plist) {
    _plist = plist;
  }

  // static getPlist(path) {
  //   return PlistParser().parseFileSync(p.join(path as String, 'soundset.plist'));
  // }

  static getPlist(path) {
    File file = File(p.join(path as String, 'soundset.plist'));
    String plist = file.readAsStringSync();
    var list = PropertyListSerialization.propertyListWithString(plist);
    return list;
  }

  static savePlist(SoundSet set) async {
    final soundsetFile = p.join(set.path as String, 'soundset.plist');

    File file = File(soundsetFile);
    String plist = await file.readAsString();

    var dict = PropertyListSerialization.propertyListWithString(plist) as Map;
    dict['SoundSetUserString'] = set.description;
    dict['SoundSetURL'] = set.repo;
    dict['SoundSetDownloadURL'] = '${set.download}';

    var result = PropertyListSerialization.stringWithPropertyList(dict);

    File(soundsetFile).writeAsStringSync(result);
  }

  SoundSet.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        description = json['description'] as String,
        repo = json['repo'] as String,
        download = json['download'] as String,
        tmp = true;

  factory SoundSet.fromPath(name, path) {
    var plist = getPlist(path);
    return SoundSet(
      name: name.replaceAll('.eragesoundset', ''),
      description: plist['SoundSetUserString'],
      repo: plist['SoundSetURL'],
      download: plist['SoundSetDownloadURL'],
      path: path,
      tmp: false,
    );
  }
}
