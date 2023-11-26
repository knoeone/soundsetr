import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:macos_window_utils/macos_window_utils.dart';

import 'installed.dart';

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
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MacosApp(
      //title: 'soundset_market',
      theme: MacosThemeData.light(),
      darkTheme: MacosThemeData.dark(),
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
          backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
          sidebar: SideBar(),
          child: IndexedStack(
            index: _pageIndex,
            children: const [
              //HomePage(),
              Text("Asd")
            ],
          ),
        ),
      ),
    );
  }

  Sidebar SideBar() {
    return Sidebar(
      minWidth: 200,
      builder: (context, scrollController) => SidebarItems(
        currentIndex: _pageIndex,
        onChanged: (index) {
          setState(() => _pageIndex = index);
        },
        items: const [
          SidebarItem(
            leading: MacosIcon(CupertinoIcons.home),
            label: Text('Home'),
          ),
          SidebarItem(
            leading: MacosIcon(CupertinoIcons.folder),
            label: Text('Installed'),
          ),
          SidebarItem(
            leading: MacosIcon(CupertinoIcons.cloud),
            label: Text('Market'),
          ),
          SidebarItem(
            leading: MacosIcon(CupertinoIcons.speaker_2),
            label: Text('Setup'),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
            title: const Text('Home'),
          ),
          children: [
            ContentArea(
              builder: (context, scrollController) {
                return Installed(scrollController: scrollController);
              },
            ),
          ],
        );
      },
    );
  }
}
