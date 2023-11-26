import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/scaffold.dart';

class SoundsetScreen extends StatelessWidget {
  final ScrollController? scrollController;
  const SoundsetScreen({super.key, this.scrollController});
  static Route<dynamic> route() {
    return CupertinoPageRoute(
      builder: (BuildContext context) {
        return const SoundSetDetailScreen();
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
      canBack: true,
      title: const Text('SoundSet'),
      child: Container(color: Colors.red),
    );
  }
}
