import 'package:plexlit/plexlit.dart';
import 'package:plexlit/plexlit.dart';

// Package imports:
import 'package:connectivity_plus/connectivity_plus.dart';


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
                // Network gard
                VGuard(
                  beforeEnter: (redirect) async {
                    if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
                      return redirect.to('/error/offline');
                    }
                  },
                  stackedRoutes: [
                    VWidget(path: "library", widget: const LibraryScreen()),
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

                VWidget(path: null, widget: const HomeScreen()),
                VWidget(path: "settings", widget: const SettingsScreen()),
                VWidget(path: "downloads", widget: const DownloadsScreen()),

                VWidget.builder(
                  path: "downloads/:id",
                  builder: (ctx, route) => AudioBookScreen(
                    route.queryParameters["id"]!,
                    offline: true,
                  ),
                ),

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
