import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

class Toggle extends StatelessWidget {
  final bool hideIfToggled;
  const Toggle({super.key, this.hideIfToggled = false});

  @override
  Widget build(BuildContext context) {
    if (hideIfToggled && MacosWindowScope.of(context).isSidebarShown) {
      return SizedBox();
    }
    return SizedBox(
      height: 40,
      width: 40,
      child: MacosTooltip(
        message: 'Toggle Sidebar',
        useMousePosition: false,
        child: MacosIconButton(
          icon: MacosIcon(
            CupertinoIcons.sidebar_left,
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
          onPressed: () => MacosWindowScope.of(context).toggleSidebar(),
        ),
      ),
    );
  }
}
