import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:path/path.dart' as p;
import 'package:watcher/watcher.dart';
import 'dart:io' as io;
import '../main.dart';
import '../widgets/download.dart';

class SoundsetScreen extends StatelessWidget {
  final ScrollController? scrollController;
  const SoundsetScreen({super.key, this.scrollController});
  static Route<dynamic> route() {
    return CupertinoPageRoute(
      builder: (BuildContext context) {
        return SoundSetDetailScreen();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SoundSetDetailScreen extends StatelessWidget {
  const SoundSetDetailScreen({super.key});
  @override
  Widget build(BuildContext context) {
//    return Container(width: 100, height: 100, color: Colors.red);
    return ScaffoldScreen(
      title: const Text('SoundSet'),
      child: Container(color: Colors.red),
    );
  }
}
