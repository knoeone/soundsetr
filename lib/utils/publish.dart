import 'package:app_links/app_links.dart';
import 'package:url_launcher/url_launcher.dart';

import 'config.dart';

abstract class Publish {
  static final _appLinks = AppLinks();

  static init() {
    // (Use allStringLinkStream to get it as [String])
    _appLinks.allUriLinkStream.listen((uri) {
      print(uri);
      // Do something (navigation, ...)
    });

    _appLinks.uriLinkStream.listen((uri) {
      print('asdasd $uri');

      // Do something (navigation, ...)
    });
  }

  static auth({refresh = false}) {
    //if (refresh || !refresh && Config.githubToken.isNotEmpty) return;

    launchUrl(
      Uri.parse(
        'https://github.com/login/oauth/authorize?client_id=${Config.githubClientId}&scope=public_repo',
      ),
    );
  }
}
