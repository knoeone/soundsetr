import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

class Duplicate extends StatelessWidget {
  const Duplicate({super.key});

  @override
  Widget build(BuildContext context) {
    // return ToolBarIconButton(
    //   label: "Duplicate SoundSet",
    //   icon: const MacosIcon(
    //     CupertinoIcons.doc_on_clipboard,
    //   ),
    //   onPressed: () => MacosWindowScope.of(context).toggleSidebar(),
    //   showLabel: false,
    // );

    return SizedBox(
      height: 40,
      width: 40,
      child: MacosTooltip(
        message: 'Duplicate SoundSet',
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
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}
