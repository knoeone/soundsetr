import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:path/path.dart' as p;
import 'dart:io' as io;

abstract class Config {
  static String pathDefault = p.join(
    p.absolute(
      io.Platform.environment['HOME'] as String,
      'Library/Group Containers/UBF8T346G9.Office/Outlook/Outlook Sound Sets',
    ),
  );
  static String outlookResourcePathDefault = p.join(
    p.absolute(
      io.Platform.environment['HOME'] as String,
      'Applications/Microsoft Outlook.app/Contents/Frameworks/OutlookCore.framework/Resources',
    ),
  );
  static String repositoryDefault =
      'https://github.com/knoeone/soundsetr-soundsets/releases/download/soundsets.json/soundsets.json';

  static String _path = pathDefault;
  static String _outlookResourcePath = outlookResourcePathDefault;
  static String _repository = repositoryDefault;
  static String _githubToken = '';
  static String githubClientId = '331853a44a2c5dfad169';

  static late StreamingSharedPreferences prefs;

  static String get path => _path;
  static String get outlookResourcePath => _outlookResourcePath;
  static String get repository => _repository;
  static String get githubToken => _githubToken;

  static set path(String value) {
    if (_path == value) return;
    _path = value;
    prefs.setString('path', value);
  }

  static set outlookResourcePath(String value) {
    if (_outlookResourcePath == value) return;
    _outlookResourcePath = value;
    prefs.setString('outlookResourcePath', value);
  }

  static set repository(String value) {
    if (_repository == value) return;
    _repository = value;
    prefs.setString('repository', value);
  }

  static set githubToken(String value) {
    if (_githubToken == value) return;
    _githubToken = value;
    prefs.setString('githubToken', value);
  }

  static void init() async {
    prefs = await StreamingSharedPreferences.instance;
    prefs.getString('gethubToken', defaultValue: '').listen((value) {
      print('loading token $value');
      _githubToken = value;
    });
    prefs.getString('path', defaultValue: pathDefault).listen((value) {
      _path = value;
    });
    prefs.getString('repository', defaultValue: repositoryDefault).listen((value) {
      _repository = value;
    });
    prefs
        .getString('outlookResourcePath', defaultValue: outlookResourcePathDefault)
        .listen((value) {
      _outlookResourcePath = value;
    });
  }
}
