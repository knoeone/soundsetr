import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;
import 'package:propertylistserialization/propertylistserialization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:io/io.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sanitize_filename/sanitize_filename.dart';

import '../../utils/downloader.dart';
import '../../utils/config.dart';
//import 'soundset_type.dart';

part 'create.dart';
part 'cache.dart';
part 'duplicate.dart';
part 'delete.dart';
part 'exists.dart';
part 'get.dart';
part 'replace_select.dart';
part 'replace_file.dart';
part 'save_audio.dart';
part 'plist.dart';

class SoundSet {
  String name;
  String? icon;
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
    this.icon,
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

  static createPathByName(name) {
    return p.join(Config.path,
        '${sanitizeFilename(name).replaceAll('.zip', '').replaceAll('.eragesoundset', '')}.eragesoundset');
  }

  static createNew(name) => createNewSoundSet(name);
  static getPlist(path) => getSoundSetPlist(path);

  // some sort if strange behavior when being called from DropTarget.onDragDone
  //   requires us to have this non extension method
  replaceFile(type, file) => replace(type, file);

  SoundSet.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        description = json['description'] as String,
        repo = json['repo'] as String,
        download = json['download'] as String,
        icon = json['icon'] as String,
        tmp = true;

  factory SoundSet.fromPath(name, path) {
    var plist = SoundSet.getPlist(path);
    return SoundSet(
      name: name.replaceAll('.eragesoundset', ''),
      description: plist['SoundSetUserString'],
      repo: plist['SoundSetURL'],
      download: plist['SoundSetDownloadURL'],
      icon: plist['ImageFile_Icon'],
      path: path,
      tmp: false,
    );
  }
}
