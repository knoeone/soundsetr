import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

abstract class Config {
  static String pathDefault =
      '/Users/spacedevin/Library/Group Containers/UBF8T346G9.Office/Outlook/Outlook Sound Sets';
  static String outlookResourcePathDefault =
      '/Applications/Microsoft Outlook.app/Contents/Frameworks/OutlookCore.framework/Resources';
  static String repositoryDefault =
      'https://raw.githubusercontent.com/knoeone/soundsetr/main/soundsets/soundsets.json';

  static String _path = pathDefault;
  static String _outlookResourcePath = outlookResourcePathDefault;
  static String _repository = repositoryDefault;

  static late StreamingSharedPreferences prefs;

  static String get path => _path;
  static String get outlookResourcePath => _outlookResourcePath;
  static String get repository => _repository;

  static set path(String value) {
    if (_path == value) return;
    _path = value;
    print('setting to $value');
    prefs.setString('path', value);
  }

  static set outlookResourcePath(String value) {
    _outlookResourcePath = value;
    prefs.setString('outlookResourcePath', value);
  }

  static set repository(String value) {
    _repository = value;
    prefs.setString('repository', value);
  }

  static void init() async {
    prefs = await StreamingSharedPreferences.instance;
    prefs.getString('path', defaultValue: pathDefault).listen((value) {
      _path = value;
    });
    prefs.getString('path', defaultValue: repositoryDefault).listen((value) {
      _repository = value;
    });
    prefs.getString('path', defaultValue: outlookResourcePathDefault).listen((value) {
      _outlookResourcePath = value;
    });
  }
}
