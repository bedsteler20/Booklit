// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:connectivity_plus/connectivity_plus.dart';

// Project imports:
import 'package:booklit/booklit.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return VRouter(
      theme: materialYouTheme,
      debugShowCheckedModeBanner: false,
      title: "Booklit",
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
                // Network gard
                VGuard(
                  beforeEnter: (redirect) async {
                    if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
                      return redirect.to('/error/offline');
                    }
                  },
                  stackedRoutes: [
                    VWidget(
                      path: "library",
                      widget: const LibraryScreen(),
                      // buildTransition: (_, __, child) => child,
                    ),
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
                ),

                VWidget(
                  path: null,
                  widget: const HomeScreen(),
                  // buildTransition: (_, __, child) => child,
                ),
                VWidget(
                  path: "settings",
                  widget: const SettingsScreen(),
                  // buildTransition: (_, __, child) => child,
                ),

                if (kDownloadsEnabled) ...[
                  VWidget(
                    path: "downloads",
                    widget: const DownloadsScreen(),
                  ),
                  VWidget.builder(
                    path: "downloads/:id",
                    builder: (ctx, route) => AudioBookScreen(
                      route.queryParameters["id"]!,
                      offline: true,
                    ),
                  )
                ],

                VWidget(path: "error/offline", widget: const OfflineScreen()),
              ],
            )
          ],
        ),
        VWidget(path: "/auth", widget: const AuthScreen()),
      ],
    );
  }
}
