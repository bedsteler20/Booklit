// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:miniplayer/miniplayer.dart';
import 'package:provider/src/provider.dart';

// Project imports:
import 'package:plexlit/routes.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key, this.direction = Axis.horizontal}) : super(key: key);
  final Axis direction;
  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int currentIndex = 0;

  bool get isVisible {
    if (routeName.value == "/login") return false;
    if (routeName.value == "/plex/servers") return false;
    if (routeName.value == "/plex/librarys") return false;
    return true;
  }

  void onChange(int i) {
    context
        .read<MiniplayerController>()
        .animateToHeight(state: PanelState.MIN, duration: const Duration(milliseconds: 100));
    setState(() => currentIndex = i);
    switch (i) {
      case 0:
        router.currentState?.pushNamedAndRemoveUntil("/", (route) => true);
        break;
      case 1:
        router.currentState?.pushNamedAndRemoveUntil("/library", (route) => true);
        break;
      case 2:
        router.currentState?.pushNamedAndRemoveUntil("/settings", (route) => true);
        break;
    }
  }

  List<NavigationDestination> navBarItems = [
    NavigationDestination(
      icon: Icon(Icons.home_outlined, color: Colors.grey.shade400),
      label: "Home",
      selectedIcon: const Icon(Icons.home_rounded, color: Colors.black),
    ),
    NavigationDestination(
      icon: Icon(Icons.library_books_outlined, color: Colors.grey.shade400),
      label: "Library",
      selectedIcon: const Icon(Icons.library_books_rounded, color: Colors.black),
    ),
    NavigationDestination(
      icon: Icon(Icons.settings_outlined, color: Colors.grey.shade400),
      label: "Settings",
      selectedIcon: const Icon(Icons.settings_rounded, color: Colors.black),
    ),
  ];

  List<NavigationRailDestination> navRailItems = const [
    NavigationRailDestination(
      icon: Icon(Icons.home_outlined),
      label: Text("Home"),
      selectedIcon: Icon(Icons.home),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.library_books_outlined),
      label: Text("Library"),
      selectedIcon: Icon(Icons.library_books),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.settings_outlined),
      label: Text("Settings"),
      selectedIcon: Icon(Icons.settings),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: routeName,
        builder: (context, _, __) {
          if (isVisible) {
            if (widget.direction == Axis.vertical) {
              return SizedBox(
                width: 80,
                child: NavigationRail(
                  destinations: navRailItems,
                  selectedIndex: currentIndex,
                  onDestinationSelected: onChange,
                ),
              );
            } else {
              return NavigationBar(
                onDestinationSelected: onChange,
                selectedIndex: currentIndex,
                destinations: navBarItems,
              );
            }
          } else {
            return const SizedBox();
          }
        });
  }
}
