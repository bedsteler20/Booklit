// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:miniplayer/miniplayer.dart';

// Project imports:
import 'package:plexlit/routes.dart';

class AppController with ChangeNotifier {
  AppController(this.context);
  BuildContext context;
  var scaffolrKey = GlobalKey<ScaffoldMessengerState>();
  var routerKey = GlobalKey();
  var miniplayerController = MiniplayerController();

  var miniPlayerHeight = ValueNotifier<double>(80.0);
  var _navIndex = 0;
  var _isNavbarVisible = true;

  int get navIndex => _navIndex;
  bool get isNavbarVisible => _isNavbarVisible;

  set navIndex(int i) {
    _navIndex = i;
    notifyListeners();
  }

  set isNavbarVisible(bool i) {
    _isNavbarVisible = i;
    notifyListeners();
  }

  // late RoutemasterDelegate router = RoutemasterDelegate(
  //   routesBuilder: (_) => Routes(context).map,
  //   observers: [
  //     _RouteObserver((route) {
  //       switch (route.path) {
  //         case "/":
  //           navIndex = 0;
  //           break;
  //         case "/library":
  //           navIndex = 1;
  //           break;
  //         case "/settings":
  //           navIndex = 2;
  //           break;
  //       }

  //       isNavbarVisible = route.path.startsWith("/setup");
  //     })
  //   ],
  // );

}
