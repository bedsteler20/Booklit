// Flutter imports:
import 'package:flutter/material.dart';
import 'package:plexlit/auth/auth.dart';
import 'package:plexlit/auth/plex/server_picker.dart';
import 'package:plexlit/helpers/context.dart';
import 'package:plexlit/providers/api_provider.dart';
import 'package:plexlit/screens/auth_screen.dart';
import 'package:provider/src/provider.dart';

// Package imports:
import 'package:vrouter/vrouter.dart';

// Project imports:
import 'package:plexlit/screens/audiobook_screen.dart';
import 'package:plexlit/screens/home_screen.dart';
import 'package:plexlit/screens/library_screen.dart';
import 'package:plexlit/screens/media_group_screen.dart';
import 'package:plexlit/screens/setting_screen.dart';
import 'package:plexlit/theme/material_you_theme.dart';
import 'package:plexlit/widgets/app/scaffold.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VRouter(
      theme: materialYouTheme(),
      debugShowCheckedModeBanner: false,
      title: "Plexlit",
      onSystemPop: (redirect) async {
        if (redirect.historyCanBack()) redirect.historyBack();
      },
      routes: [
        VGuard(
          beforeEnter: (redirect) async => context.repository == null ? redirect.to('/auth') : null,
          stackedRoutes: [
            VNester(
              path: "/",
              widgetBuilder: (child) => AppScaffold(child),
              nestedRoutes: [
                VWidget(path: null, widget: const HomeScreen()),
                VWidget(path: "library", widget: const LibraryScreen()),
                VWidget(path: "settings", widget: const SettingsScreen()),
                VWidget.builder(
                  path: "collection/:id",
                  builder: (ctx, route) => MediaGroupScreen(route),
                ),
                VWidget.builder(
                  path: "genre/:id",
                  builder: (ctx, route) => MediaGroupScreen(route),
                ),
                VWidget.builder(
                  path: "audiobook/:id",
                  builder: (ctx, route) => AudioBookScreen(route.queryParameters["id"]!),
                ),
              ],
            )
          ],
        ),
        VWidget(path: "/auth", widget: const AuthScreen()),
      ],
    );
  }
}
