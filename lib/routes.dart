// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';
import 'package:provider/src/provider.dart';
import 'package:vrouter/vrouter.dart';

// Project imports:
import 'package:plexlit/providers/api_provider.dart';
import 'package:plexlit/screens/audiobook_screen.dart';
import 'package:plexlit/screens/home_screen.dart';
import 'package:plexlit/screens/library_screen.dart';
import 'package:plexlit/screens/media_group_screen.dart';
import 'package:plexlit/screens/setting_screen.dart';
import 'package:plexlit/screens/unknown_route_screen.dart';
import 'package:plexlit/theme/material_you_theme.dart';

class AppRouter extends StatelessWidget {
  const AppRouter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VRouter(
      checkerboardOffscreenLayers: false,
      debugShowCheckedModeBanner: false,
      initialUrl: '/',
      theme: materialYouTheme(),
      routes: [
        VNester(
          path: '/',
          widgetBuilder: (child) => Scaffold(body: child),
          nestedRoutes: [
            VWidget(
              path: null,
              widget: const Center(
                child: Text("Hello World"),
              ),
            ),
          ],
        )
      ],
    );
  }
}
