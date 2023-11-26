import 'package:plist_parser/plist_parser.dart';
import 'package:path/path.dart' as p;

class SoundSet {
  String name;
  String description;
  String repo;
  String? download;
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

  static getPlist(path) {
    return PlistParser().parseFileSync(p.join(path as String, 'soundset.plist'));
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
