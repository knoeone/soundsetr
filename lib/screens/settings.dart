import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

import '../utils/config.dart';
import '../widgets/reset.dart';
import '../widgets/reveal.dart';

class SettingsScreen extends StatelessWidget {
  final ScrollController? scrollController;
  const SettingsScreen({super.key, this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingItem(
          setting: Config.path,
          onChange: (value) => Config.path = value,
          defaultValue: Config.pathDefault,
          name: 'Outlook SoundSet Path',
        ),
        SettingItem(
          setting: Config.repository,
          onChange: (value) => Config.repository = value,
          defaultValue: Config.repositoryDefault,
          name: 'SoundSet Repository URL Endpoint',
        ),
      ],
    );
  }
}

class SettingItem extends StatefulWidget {
  final String setting;
  final String name;
  final Function onChange;
  final String defaultValue;

  const SettingItem({
    super.key,
    required this.setting,
    required this.name,
    required this.onChange,
    required this.defaultValue,
  });

  @override
  State<SettingItem> createState() => _SettingItemState();
}

class _SettingItemState extends State<SettingItem> {
  var controller = TextEditingController();

  void resetDefault() {
    controller.text = widget.defaultValue;
    widget.onChange(widget.defaultValue);
  }

  @override
  void initState() {
    super.initState();
    controller.text = widget.setting;
    controller.addListener(() {
      print("settings changed from text");
      widget.onChange(controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    // controller.addListener(() {
    //   print("settings changed from text");
    //   onChange(controller.text);
    // });

    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.name),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: MacosTextField(
                  controller: controller,
                  padding: const EdgeInsets.all(12.0),
                  placeholder: '',
                ),
              ),
              const SizedBox(width: 10),
              ResetButton(onPressed: resetDefault),
              RevealButton(file: controller.text)
            ],
          ),
        ],
      ),
    );
  }
}
