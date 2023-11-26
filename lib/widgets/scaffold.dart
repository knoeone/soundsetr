import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'back.dart';
import 'toggle.dart';

class ScaffoldScreen extends StatelessWidget {
  final Widget? child;
  final List<Widget>? children;
  final Widget? title;
  final bool canBack;
  final List<Widget>? actions;
  final bool useSliver;
  final ScrollController? scrollController;

  const ScaffoldScreen({
    super.key,
    this.child,
    this.title,
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
      leading.add(const SizedBox(width: 8));
    }

    leading.add(const Toggle(hideIfToggled: true));
    if (!MacosWindowScope.of(context).isSidebarShown) {
      leading.add(const SizedBox(width: 8));
      leading.add(
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(20),
            width: 1,
            color: MacosTheme.of(context).dividerColor,
          ),
        ),
      );
      leading.add(const SizedBox(width: 8));
    }

    if (canBack) {
      leading.add(const Flexible(
        child: BackButton(),
      ));
    }

    leading.add(const SizedBox(width: 8));

    var a = actions ?? [];

    var titleRow = Row(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: leading,
        ),
        title != null ? Expanded(child: title as Widget) : SizedBox(),
        ...a,
      ],
    );

    if (useSliver) {
      return CustomScrollView(
        controller: scrollController,
        slivers: [
          title != null || (title == null && !MacosWindowScope.of(context).isSidebarShown)
              ? SliverToolBar(
                  automaticallyImplyLeading: false,
                  title: titleRow,
                  pinned: true,
                  floating: true,
                  toolbarOpacity: title == null ? 0 : 0.75,
                  padding: const EdgeInsets.all(0),
                  height: 0,
                )
              : SliverToBoxAdapter(),
          SliverList.list(
            children: children ?? [],
          ),
        ],
      );
    }

    return MacosScaffold(
      toolBar: title != null
          ? ToolBar(
              automaticallyImplyLeading: false,
              allowWallpaperTintingOverrides: true,
              titleWidth: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(0),
              title: titleRow,
            )
          : null,
      children: [
        ContentArea(builder: (context, scrollController) => child ?? Container()),
      ],
    );
  }
}
