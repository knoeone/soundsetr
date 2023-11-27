import 'dart:convert';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:github/github.dart';
import 'package:soundsetr/utils/downloader.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as path;

import '../models/soundset.dart';
import 'config.dart';

abstract class Publish {
  // static final _appLinks = AppLinks();

  // static init() {
  //   // (Use allStringLinkStream to get it as [String])
  //   _appLinks.allUriLinkStream.listen((uri) {
  //     print(uri);
  //     // Do something (navigation, ...)
  //   });

  //   _appLinks.uriLinkStream.listen((uri) {
  //     print('asdasd $uri');

  //     // Do something (navigation, ...)
  //   });
  // }

  static SoundSet? _publishing;

  static receiveAuth(url) {
    var uri = Uri.parse(url);
    Config.githubToken = uri.path.replaceAll('/', '');
    print('saving token ${Config.githubToken}');

    if (_publishing != null) {
      _publishing = null;
      publishSet(_publishing);
    }
  }

  static bool getAuth({refresh = false}) {
    print('getAuth ${Config.githubToken}');
    if (Config.githubToken != '' && !refresh) return true;

    launchUrl(
      Uri.parse(
        'https://github.com/login/oauth/authorize?client_id=${Config.githubClientId}&scope=public_repo',
      ),
    );
    return false;
  }

  static publishSet(set) async {
    if (set == null) return;
    _publishing = set;
    if (!getAuth()) return;

    print('pub ${Config.githubToken}');

    var github = GitHub(auth: Authentication.withToken(Config.githubToken));
    var repo = RepositorySlug('knoeone', 'soundsetr-soundsets');
    Repository fork = await github.repositories.createFork(repo);
    var forked = fork.slug();
    // var forked = RepositorySlug('spacedevin', 'soundsetr-soundsets');
    // Repository fork = await github.repositories.getRepository(forked);
    print(fork.htmlUrl);

    GitTree head = await github.git.getTree(forked, 'main');
    print(head.sha);

    GitReference main = await github.git.getReference(forked, 'heads/main');
    print(main.object?.sha);

    List<GitBlob> blobs = [];
    List<CreateGitTreeEntry> entries = [];
    DownloaderSendResponse sending = await Downloader.send(set);

    await Future.delayed(Duration(seconds: 1));

    for (var file in sending.files) {
      GitBlob blob = await github.git.createBlob(
        forked,
        CreateGitBlob(
          base64.encode(
            File(path.join(sending.path, '${set.name}.eragesoundset', file)).readAsBytesSync(),
          ),
          'base64',
        ),
      );
      print(blob);
      blobs.add(blob);
    }

    for (var x = 0; x < sending.files.length; x++) {
      GitBlob blob = blobs[x];
      entries.add(
        CreateGitTreeEntry(
          'soundsets/${set.name}.eragesoundset/${sending.files[x]}',
          '100644',
          'blob',
          sha: blob.sha,
        ),
      );
    }

    GitBlob zip = await github.git.createBlob(
      forked,
      CreateGitBlob(
        base64.encode(
          File(path.join(sending.path, sending.zip)).readAsBytesSync(),
        ),
        'base64',
      ),
    );

    entries.add(CreateGitTreeEntry(
      'dist/${set.name}.eragesoundset.zip',
      '100644',
      'blob',
      sha: zip.sha,
    ));

    GitTree tree = await github.git.createTree(forked, CreateGitTree(entries, baseTree: head.sha));
    GitCommit commit = await github.git.createCommit(
      forked,
      CreateGitCommit('Publishing ${set.name} using Soundsetr', tree.sha, parents: [head.sha]),
    );

    GitReference results = await github.git.editReference(forked, 'heads/main', commit.sha);

    print(commit);
    print(commit.message);
    print(results.object?.sha);

    var commitUrl = 'https://github.com/${forked.fullName}/commit/${results.object?.sha}';
    launchUrl(Uri.parse(commitUrl));

    return commitUrl;
  }
}
