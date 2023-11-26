import 'package:flutter/cupertino.dart';
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
    return MacosScaffold(
      toolBar: ToolBar(
        // alignment: Alignment.centerLeft,
        // leading: Back(),
        //MacosWindowScope.of(context).isSidebarShown ? SizedBox(width: 1, height: 1) : Toggle(),

        leading: canBack
            ? MacosBackButton(
                onPressed: () => Navigator.of(context).pop(),
                fillColor: MacosColors.transparent,
              )
            : SizedBox(),
        actions: false //MacosWindowScope.of(context).isSidebarShown
            ? null
            : [
                ToolBarIconButton(
                  label: "Delete",
                  icon: const MacosIcon(
                    CupertinoIcons.sidebar_left,
                  ),
                  onPressed: () => MacosWindowScope.of(context).toggleSidebar(),
                  showLabel: false,
                ),
              ],
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
