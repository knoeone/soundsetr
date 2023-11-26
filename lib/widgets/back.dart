import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

class Back extends StatelessWidget {
  const Back({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: MacosTooltip(
        message: 'Toggle Sidebar',
        useMousePosition: false,
        child: MacosIconButton(
          icon: MacosIcon(
            CupertinoIcons.back,
            color: MacosTheme.brightnessOf(context).resolve(
              const Color.fromRGBO(0, 0, 0, 0.5),
              const Color.fromRGBO(255, 255, 255, 0.5),
            ),
            size: 20.0,
          ),
          boxConstraints: const BoxConstraints(
              // minHeight: 20,
              // minWidth: 20,
              // maxWidth: 48,
              // maxHeight: 38,
              ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}
