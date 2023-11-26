import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:soundset_market/screens/soundset.dart';
import 'package:system_theme/system_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';
import 'screens/contribute.dart';
import 'screens/installed.dart';
import 'screens/market.dart';
import 'screens/setup.dart';
import 'widgets/scaffold.dart';
import 'widgets/toggle.dart';
import 'widgets/window.dart';

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

  void goToIndex(index) {
    setState(() => _pageIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutExpo,
      child: PlatformMenuBar(
        menus: [
          PlatformMenu(
            label: 'SoundsetMarket',
            menus: [
              PlatformProvidedMenuItem(
                type: PlatformProvidedMenuItemType.about,
              ),
              PlatformMenuItem(
                  label: 'Open Outlook', onSelected: () => launchUrl(Uri.parse('ms-outlook://'))),
              PlatformProvidedMenuItem(
                type: PlatformProvidedMenuItemType.quit,
              ),
            ],
          ),
        ],
        child: OtherMacosWindow(
          backgroundColor: const Color.fromRGBO(0, 0, 0, 0.0),
          sidebar: Sidebar(
            padding: const EdgeInsets.all(0),
            top: const Toggle(),
            topOffset: 0,
            bottom: Container(
              alignment: Alignment.bottomLeft,
              child: const HelpButton(),
            ),
            minWidth: 200,
            builder: SideBar,
          ),
          child: IndexedStack(
            index: _pageIndex,
            children: [
              ScaffoldScreen(
                title: const Text('Get Started'),
                child: Container(),
              ),
              CupertinoTabView(builder: (context) {
                return ScaffoldScreen(
                  title: const Text('Installed'),
                  child: InstalledScreen(),
                );
              }),
              CupertinoTabView(builder: (context) {
                return ScaffoldScreen(
                  title: const Text('Store'),
                  child: MarketScreen(),
                );
              }),
              ScaffoldScreen(
                title: const Text('Contribute'),
                child: ContributeScreen(),
              ),
              ScaffoldScreen(
                title: const Text('Outlook Settings'),
                child: SetupScreen(goToIndex: goToIndex),
              ),
            ],
          ),
        ),
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
            CupertinoIcons.flag,
            color: _pageIndex == 0 ? iconColor : SystemTheme.accentColor.accent,
          ),
          label: Text(
            'Get Started',
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
            CupertinoIcons.sparkles,
            color: _pageIndex == 3 ? iconColor : SystemTheme.accentColor.accent,
          ),
          label: Text('Contribute'),
        ),
        SidebarItem(
          leading: MacosIcon(
            CupertinoIcons.settings,
            color: _pageIndex == 4 ? iconColor : SystemTheme.accentColor.accent,
          ),
          label: Text('Outlook Settings'),
        ),
      ],
    );
  }
}
