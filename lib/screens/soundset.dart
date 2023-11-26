import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/scaffold.dart';

class SoundsetScreen extends StatelessWidget {
  final ScrollController? scrollController;
  const SoundsetScreen({super.key, this.scrollController});

  static Route<dynamic> route({required item}) {
    return CupertinoPageRoute(
      builder: (BuildContext context) {
        return SoundSetDetailScreen(item: item);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SoundSetDetailScreen extends StatelessWidget {
  final item;
  const SoundSetDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
//    return Container(width: 100, height: 100, color: Colors.red);
    return ScaffoldScreen(
      canBack: true,
      title: Text(item['name']),
      child: Container(color: Colors.red),
    );
  }
}
