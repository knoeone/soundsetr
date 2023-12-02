import 'package:path/path.dart' as p;
import 'package:sanitize_filename/sanitize_filename.dart';
import '../../utils/config.dart';

mixin Path {
  static createSoundsetPathByName(name) {
    return p.join(Config.path,
        '${sanitizeFilename(name).replaceAll('.zip', '').replaceAll('.eragesoundset', '')}.eragesoundset');
  }
}
