// Flutter imports:
import 'package:flutter/material.dart';

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

  List<BottomNavigationBarItem> items = const [
    BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
    BottomNavigationBarItem(icon: Icon(Icons.library_books_outlined), label: "Library"),
    BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: "Settings"),
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
                  destinations: items.map((e) => e.toDestination()).toList(),
                  selectedIndex: currentIndex,
                  onDestinationSelected: onChange,
                ),
              );
            } else {
              return BottomNavigationBar(
                currentIndex: currentIndex,
                onTap: onChange,
                items: items,
              );
            }
          } else {
            return const SizedBox();
          }
        });
  }
}

extension on BottomNavigationBarItem {
  NavigationRailDestination toDestination() =>
      NavigationRailDestination(icon: icon, label: Text(label ?? ""), selectedIcon: activeIcon);
}
