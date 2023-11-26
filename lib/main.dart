import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:system_theme/system_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';
import 'screens/contribute.dart';
import 'screens/installed.dart';
import 'screens/market.dart';
import 'screens/settings.dart';
import 'screens/setup.dart';
import 'utils/config.dart';
import 'widgets/create.dart';
import 'widgets/scaffold.dart';
import 'widgets/toggle.dart';
import 'widgets/window.dart';

/// This method initializes macos_window_utils and styles the window.
Future<void> _configureMacosWindowUtils() async {
  const config = MacosWindowUtilsConfig();
  await config.apply();
  Config.init();
  // await WindowManipulator.makeTitlebarTransparent();
  // await WindowManipulator.setWindowBackgroundColorToClear();
  // WindowManipulator.makeWindowFullyTransparent();
  // await WindowManipulator.setMaterial(
  //   NSVisualEffectViewMaterial.toolTip,
  // );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemTheme.accentColor.load();

  await _configureMacosWindowUtils();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    minimumSize: Size(800, 600),
  );
  // windowManager.waitUntilReadyToShow(windowOptions, () async {
  //   await windowManager.show();
  //   await windowManager.focus();
  // });
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MacosApp(
      theme: MacosThemeData.light().copyWith(
        primaryColor: SystemTheme.accentColor.accent,
      ),
      darkTheme: MacosThemeData.dark().copyWith(
        primaryColor: SystemTheme.accentColor.accent,
        //typography: MacosTypography(color: Colors.white),
      ),
      themeMode: ThemeMode.system,
      //themeMode: ThemeMode.light,
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
            label: 'Soundsetr',
            menus: [
              const PlatformProvidedMenuItem(
                type: PlatformProvidedMenuItemType.about,
              ),
              PlatformMenuItem(
                  label: 'Open Outlook', onSelected: () => launchUrl(Uri.parse('ms-outlook://'))),
              const PlatformProvidedMenuItem(
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
            builder: sideBar,
          ),
          child: IndexedStack(
            index: _pageIndex,
            children: [
              SetupScreen(goToIndex: goToIndex),
              CupertinoTabView(builder: (context) {
                return const ScaffoldScreen(
                  title: Text('Installed'),
                  actions: [CreateButton()],
                  child: InstalledScreen(),
                );
              }),
              CupertinoTabView(builder: (context) {
                return const ScaffoldScreen(
                  title: Text('Store'),
                  child: MarketScreen(),
                );
              }),
              const ScaffoldScreen(
                title: Text('Contribute'),
                child: ContributeScreen(),
              ),
              const ScaffoldScreen(
                title: Text('Settings'),
                child: SettingsScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sideBar(BuildContext? context, ScrollController? scrollController) {
    var readableColor = MacosTheme.brightnessOf(context as BuildContext).resolve(
      const Color.fromRGBO(0, 0, 0, 1),
      const Color.fromRGBO(255, 255, 255, 1),
    );
    // var selectedColor = MacosTheme.brightnessOf(context as BuildContext).resolve(
    //   const Color.fromRGBO(255, 255, 255, 1),
    //   const Color.fromRGBO(0, 0, 0, 1),
    // );
    var selectedColor = const Color.fromRGBO(255, 255, 255, 1);
    //var iconColor = SystemTheme.accentColor.accent;
    //var iconColor = CupertinoColors.secondaryLabel.color;

    return SidebarItems(
      //selectedColor: SystemTheme.accentColor.accent,
      //selectedColor: MacosColors.alternatingContentBackgroundColor.withOpacity(0.2),
      selectedColor: SystemTheme.accentColor.accent,
      itemSize: SidebarItemSize.medium,
      currentIndex: _pageIndex,
      scrollController: scrollController,
      onChanged: (index) {
        setState(() => _pageIndex = index);
      },
      items: [
        SidebarItem(
          leading: MacosIcon(
            CupertinoIcons.flag,
            color: _pageIndex == 0 ? selectedColor : SystemTheme.accentColor.accent,
          ),
          label: Text(
            'Get Started',
            style: TextStyle(color: _pageIndex == 0 ? selectedColor : readableColor),
          ),
        ),
        SidebarItem(
          leading: MacosIcon(
            CupertinoIcons.folder,
            color: _pageIndex == 1 ? selectedColor : SystemTheme.accentColor.accent,
          ),
          label: Text(
            'Installed',
            style: TextStyle(color: _pageIndex == 1 ? selectedColor : readableColor),
          ),
        ),
        SidebarItem(
          leading: MacosIcon(
            CupertinoIcons.cloud,
            color: _pageIndex == 2 ? selectedColor : SystemTheme.accentColor.accent,
          ),
          label: Text(
            'Store',
            style: TextStyle(color: _pageIndex == 2 ? selectedColor : readableColor),
          ),
        ),
        SidebarItem(
          leading: MacosIcon(
            CupertinoIcons.sparkles,
            color: _pageIndex == 3 ? selectedColor : SystemTheme.accentColor.accent,
          ),
          label: Text(
            'Contribute',
            style: TextStyle(color: _pageIndex == 3 ? selectedColor : readableColor),
          ),
        ),
        SidebarItem(
          leading: MacosIcon(
            CupertinoIcons.wrench,
            color: _pageIndex == 4 ? selectedColor : SystemTheme.accentColor.accent,
          ),
          label: Text(
            'Settings',
            style: TextStyle(color: _pageIndex == 4 ? selectedColor : readableColor),
          ),
        ),
      ],
    );
  }
}
