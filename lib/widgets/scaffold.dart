import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'back.dart';
import 'toggle.dart';

class ScaffoldScreen extends StatelessWidget {
  final Widget child;
  final Widget title;
  final bool canBack;
  final List<Widget>? actions;

  const ScaffoldScreen({
    super.key,
    required this.child,
    required this.title,
    this.canBack = false,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> leading = [];
    if (!MacosWindowScope.of(context).isSidebarShown) {
      leading.add(SizedBox(width: 8));
    }

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

    leading.add(SizedBox(width: 8));

    var a = actions ?? [];

    return MacosScaffold(
      toolBar: ToolBar(
        automaticallyImplyLeading: false,
        titleWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(0),
        // alignment: Alignment.centerLeft,
        // leading: Back(),
        title: Row(
          children: [
            Row(
              children: leading,
              mainAxisSize: MainAxisSize.min,
            ),
            Expanded(child: title),
            ...a,
          ],
        ),
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
