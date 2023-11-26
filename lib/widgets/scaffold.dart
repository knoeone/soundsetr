import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'back.dart';
import 'toggle.dart';

class ScaffoldScreen extends StatelessWidget {
  final Widget child;
  final Widget title;
  final bool canBack;
  const ScaffoldScreen({
    super.key,
    required this.child,
    required this.title,
    this.canBack = false,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> leading = [];
    leading.add(SizedBox(width: 8));

    leading.add(Toggle(hideIfToggled: true));
    if (!MacosWindowScope.of(context).isSidebarShown) {
      leading.add(SizedBox(width: 8));
      leading.add(
        Flexible(
          child: Container(
            padding: EdgeInsets.all(20),
            width: 1,
            color: MacosTheme.of(context).dividerColor,
          ),
        ),
      );
      leading.add(SizedBox(width: 8));
    }

    if (canBack) {
      leading.add(Flexible(
        child: Back(),
      ));
    }

    return MacosScaffold(
      toolBar: ToolBar(
        padding: EdgeInsets.all(0),
        // alignment: Alignment.centerLeft,
        // leading: Back(),
        //MacosWindowScope.of(context).isSidebarShown ? SizedBox(width: 1, height: 1) : Toggle(),

        leading: Row(
          children: leading,
          mainAxisSize: MainAxisSize.min,
        ),
        // actions: false //MacosWindowScope.of(context).isSidebarShown
        //     ? null
        //     : [
        //         ToolBarIconButton(
        //           label: "Delete",
        //           icon: const MacosIcon(
        //             CupertinoIcons.sidebar_left,
        //           ),
        //           onPressed: () => MacosWindowScope.of(context).toggleSidebar(),
        //           showLabel: false,
        //         ),
        //       ],
        title: title,
      ),
      children: [
        ContentArea(
          builder: (context, scrollController) {
            //return child(scrollController: scrollController);
            return child;
          },
        ),
      ],
    );
  }
}
