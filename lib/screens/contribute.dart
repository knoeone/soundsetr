import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../utils/downloader.dart';
import '../widgets/md.dart';

class ContributeScreen extends StatelessWidget {
  const ContributeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Md(fetch: Downloader.contributing);

    return const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Have a soundset you want to share?',
      ),
      Text(
        'Visit https://github.com/knoeone/soundsettr, fork the project, and submit a pull request with your soundset.',
      ),
      Text(
        'Have a soundset you want to share? Found a bug you need fixing? Or maybe you have an idea on how to improve Soundsetr?',
      ),
      Text(
        'Have a soundset you want to share? Found a bug you need fixing? Or maybe you have an idea on how to improve Soundsetr?',
      )
    ]);
  }
}
