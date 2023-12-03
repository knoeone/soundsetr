import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';

import '../models/soundset/soundset.dart';
import '../utils/downloader.dart';

class CreateButton extends StatelessWidget {
  const CreateButton({super.key});

  duplicateSet(context) async {
    var controller = TextEditingController();
    var focusNode = FocusNode();
    AnimationController? shakeController;

    void onComplete() {
      var name = controller.text;
      if (name == '' && shakeController != null) {
        shakeController?.forward();
        shakeController?.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            shakeController?.reset();
          }
        });
        return;
      }

      Navigator.of(context, rootNavigator: true).pop();
      SoundSet.createNew(controller.text);
    }

    showMacosAlertDialog(
      context: context,
      builder: (_) => ShakeWidget(
        duration: const Duration(milliseconds: 300),
        enableWebMouseHover: false,
        onController: (c) {
          shakeController = c;
        },
        //shakeConstant: ShakeHorizontalConstant2(),
        shakeConstant: ShakeHardConstant1(),
        autoPlay: false,
        child: MacosAlertDialog(
          appIcon: Container(
            height: 1,
          ),
          title: Text(
            'Create New SoundSet ',
            style: MacosTheme.of(context).typography.headline,
          ),
          message: Column(
            children: [
              Text(
                'Enter a name for the new SoundSet',
                textAlign: TextAlign.center,
                style: MacosTypography.of(context).body,
              ),
              const SizedBox(height: 20),
              MacosTextField(
                autocorrect: true,
                placeholder: 'New SoundSet',
                controller: controller,
                focusNode: focusNode,
                padding: const EdgeInsets.all(12),
                onSubmitted: (value) => onComplete(),
              )
            ],
          ),
          primaryButton: PushButton(
            controlSize: ControlSize.large,
            child: const Text('OK'),
            onPressed: () => onComplete(),
          ),
          secondaryButton: PushButton(
            secondary: true,
            controlSize: ControlSize.large,
            child: const Text('Cancel'),
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
        message: 'Create',
        useMousePosition: false,
        child: MacosIconButton(
          icon: MacosIcon(
            CupertinoIcons.add,
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
