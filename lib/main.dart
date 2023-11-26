import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:macos_window_utils/macos_window_utils.dart';
import 'package:soundset_market/screens/soundset.dart';
import 'package:system_theme/system_theme.dart';
import 'package:window_manager/window_manager.dart';
import 'content.dart';
import 'screens/installed.dart';
import 'screens/market.dart';

/// This method initializes macos_window_utils and styles the window.
Future<void> _configureMacosWindowUtils() async {
  const config = MacosWindowUtilsConfig();
  await config.apply();
  // await WindowManipulator.makeTitlebarTransparent();
  // await WindowManipulator.setWindowBackgroundColorToClear();
  // WindowManipulator.makeWindowFullyTransparent();
  // await WindowManipulator.setMaterial(
  //   NSVisualEffectViewMaterial.toolTip,
  // );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureMacosWindowUtils();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    minimumSize: Size(800, 600),
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MacosApp(
      //title: 'soundset_market',
      theme: MacosThemeData.light().copyWith(
        primaryColor: SystemTheme.accentColor.accent,
      ),
      darkTheme: MacosThemeData.dark().copyWith(
        primaryColor: SystemTheme.accentColor.accent,
        //typography: MacosTypography(color: Colors.white),
      ),
      themeMode: ThemeMode.system,
      home: const MainView(),
      routes: {
        '/soundset': (context) => const SoundsetScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _pageIndex = 0;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _visible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutExpo,
      child: PlatformMenuBar(
        menus: const [
          PlatformMenu(
            label: 'SoundsetMarket',
            menus: [
              PlatformProvidedMenuItem(
                type: PlatformProvidedMenuItemType.about,
              ),
              PlatformProvidedMenuItem(
                type: PlatformProvidedMenuItemType.quit,
              ),
            ],
          ),
        ],
        child: MacosWindow(
          backgroundColor: const Color.fromRGBO(0, 0, 0, 0.0),
          sidebar: Sidebar(
            bottom: Container(
              alignment: Alignment.bottomLeft,
              child: HelpButton(),
            ),
            minWidth: 200,
            builder: SideBar,
          ),
          child: IndexedStack(
            index: _pageIndex,
            children: [
              ScaffoldScreen(
                title: const Text('Home'),
                child: Container(),
              ),
              ScaffoldScreen(
                title: const Text('Installed'),
                child: InstalledScreen(),
              ),
              CupertinoTabView(builder: (context) {
                return ScaffoldScreen(
                  title: const Text('Store'),
                  child: MarketScreen(),
                );
              }),
              Container(),
              Container(),
            ],
          ),
          // child: ScaffoldScreen(
          //   title: const Text('Home'),
          //   child: IndexedStack(
          //     index: _pageIndex,
          //     children: [
          //       Container(),
          //       InstalledScreen(),
          //       MarketScreen(),
          //       Container(),
          //       Container(),
          //     ],
          //   ),
          // ),
        ),
        // child: TransparentSidebarAndContent(
        //   width: 200,
        //   isOpen: true,
        //   sidebarBuilder: SideBar,
        //   child: HomePage(),
        // ),
      ),
    );
  }

  Widget SideBar([BuildContext? context, ScrollController? scrollController]) {
    // var iconColor = MacosTheme.brightnessOf(context as BuildContext).resolve(
    //   const Color.fromRGBO(0, 0, 0, 1),
    //   const Color.fromRGBO(255, 255, 255, 1),
    // );
    var iconColor = SystemTheme.accentColor.accent;
    return SidebarItems(
      //selectedColor: SystemTheme.accentColor.accent,
      selectedColor: MacosColors.alternatingContentBackgroundColor,

      itemSize: SidebarItemSize.large,
      currentIndex: _pageIndex,
      scrollController: scrollController,
      onChanged: (index) {
        setState(() => _pageIndex = index);
      },
      items: [
        SidebarItem(
          leading: MacosIcon(
            CupertinoIcons.home,
            color: _pageIndex == 0 ? iconColor : SystemTheme.accentColor.accent,
          ),
          label: Text(
            'Home',
            style: TextStyle(color: Colors.white),
          ),
        ),
        SidebarItem(
          leading: MacosIcon(
            CupertinoIcons.folder,
            color: _pageIndex == 1 ? iconColor : SystemTheme.accentColor.accent,
          ),
          label: Text('Installed'),
        ),
        SidebarItem(
          leading: MacosIcon(
            CupertinoIcons.cloud,
            color: _pageIndex == 2 ? iconColor : SystemTheme.accentColor.accent,
          ),
          label: Text('Store'),
        ),
        SidebarItem(
          leading: MacosIcon(
            CupertinoIcons.gift,
            color: _pageIndex == 3 ? iconColor : SystemTheme.accentColor.accent,
          ),
          label: Text('Contribute'),
        ),
        SidebarItem(
          leading: MacosIcon(
            CupertinoIcons.gear,
            color: _pageIndex == 4 ? iconColor : SystemTheme.accentColor.accent,
          ),
          label: Text('Setup'),
        ),
      ],
    );
  }
}

class ScaffoldScreen extends StatelessWidget {
  Widget child;
  Widget title;
  ScaffoldScreen({
    super.key,
    required this.child,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return MacosScaffold(
          toolBar: ToolBar(
            leading: MacosTooltip(
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
                  minHeight: 20,
                  minWidth: 20,
                  maxWidth: 48,
                  maxHeight: 38,
                ),
                onPressed: () => MacosWindowScope.of(context).toggleSidebar(),
              ),
            ),
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
      },
    );
  }
}
