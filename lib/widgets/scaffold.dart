import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'back.dart';
import 'toggle.dart';

class ScaffoldScreen extends StatelessWidget {
  final Widget? child;
  final List<Widget>? children;
  final Widget title;
  final bool canBack;
  final List<Widget>? actions;
  final bool useSliver;
  final ScrollController? scrollController;

  const ScaffoldScreen({
    super.key,
    this.child,
    required this.title,
    this.canBack = false,
    this.actions,
    this.useSliver = false,
    this.scrollController,
    this.children,
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
        child: BackButton(),
      ));
    }

    leading.add(SizedBox(width: 8));

    var a = actions ?? [];

    var titleRow = Row(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: leading,
        ),
        Expanded(child: title),
        ...a,
      ],
    );

    if (useSliver) {
      return CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverToolBar(
            title: titleRow,
            pinned: true,
            toolbarOpacity: 0.75,
            padding: EdgeInsets.all(0),
          ),
          SliverList.list(
            children: children ?? [],
          ),
        ],
      );
    }

    return MacosScaffold(
      toolBar: ToolBar(
        automaticallyImplyLeading: false,
        allowWallpaperTintingOverrides: true,
        titleWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(0),
        title: titleRow,
      ),
      children: [
        ContentArea(builder: (context, scrollController) => child ?? Container()),
      ],
    );
  }
}
