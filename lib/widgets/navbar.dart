// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:plexlit/routes.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: routeName,
        builder: (context, _, __) {
          if (isVisible) {
            return BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: onChange,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
                BottomNavigationBarItem(icon: Icon(Icons.library_books_outlined), label: "Library"),
              ],
            );
          } else {
            return SizedBox();
          }
        });
  }
}
