import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';

import '../utils/downloader.dart';

class DuplicateButton extends StatelessWidget {
  final item;
  const DuplicateButton({super.key, required this.item});

  duplicateSet(context) async {
    var controller = TextEditingController();
    var focusNode = FocusNode();
    AnimationController shakeController;

    void onComplete() {
      var name = controller.text;
      if (name == '') {
        //shakeController.start();
      }

      //shakeController.stop();

      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).pop();
      Downloader.duplicate(item, controller.text);
    }

    showMacosAlertDialog(
      context: context,
      builder: (_) => ShakeWidget(
        //duration: Duration(milliseconds: 100),
        enableWebMouseHover: false,
        onController: (c) {
          shakeController = c;
        },
        shakeConstant: ShakeDefaultConstant1(),
        autoPlay: false,
        child: MacosAlertDialog(
          appIcon: Container(
            height: 1,
          ),
          title: Text(
            'Duplicate SoundSet ',
            style: MacosTheme.of(context).typography.headline,
          ),
          message: Column(
            children: [
              Text(
                'Enter a name for the new SoundSet',
                textAlign: TextAlign.center,
                style: MacosTypography.of(context).body,
              ),
              SizedBox(height: 20),
              MacosTextField(
                autocorrect: true,
                placeholder: item['name'],
                controller: controller,
                focusNode: focusNode,
                padding: const EdgeInsets.all(12),
                onSubmitted: (value) => onComplete(),
              )
            ],
          ),
          primaryButton: PushButton(
            controlSize: ControlSize.large,
            child: Text('OK'),
            onPressed: () => onComplete(),
          ),
          secondaryButton: PushButton(
            secondary: true,
            controlSize: ControlSize.large,
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ),
      ),
    );
    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: MacosTooltip(
        message: 'Duplicate ',
        useMousePosition: false,
        child: MacosIconButton(
          icon: MacosIcon(
            CupertinoIcons.doc_on_clipboard,
            color: MacosTheme.brightnessOf(context).resolve(
              const Color.fromRGBO(0, 0, 0, 0.5),
              const Color.fromRGBO(255, 255, 255, 0.5),
            ),
            size: 20.0,
          ),
          onPressed: () => duplicateSet(context),
        ),
      ),
    );
  }
}
