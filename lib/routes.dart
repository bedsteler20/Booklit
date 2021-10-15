// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';
import 'package:plexlit/screens/audiobook_screen.dart';
import 'package:plexlit/screens/media_group_screen.dart';
import 'package:provider/src/provider.dart';

// Project imports:
import 'package:plexlit/providers/api_provider.dart';
import 'package:plexlit/screens/home_screen.dart';
import 'package:plexlit/screens/library_screen.dart';
import 'package:plexlit/screens/settings/setting_screen.dart';
import 'package:plexlit/screens/unknown_route_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      redirect: (_) => ApiProvider.value.value == null ? "/setup" : null,
      pageBuilder: (c, s) => MaterialPage(
        child: const HomeScreen(),
        key: s.pageKey,
      ),
    ),
    GoRoute(
      path: "/library",
      pageBuilder: (c, s) => MaterialPage(
        child: const LibraryScreen(),
        key: s.pageKey,
      ),
    ),
    GoRoute(
      path: "/settings",
      pageBuilder: (c, s) => MaterialPage(
        child: const SettingsScreen(),
        key: s.pageKey,
      ),
    ),
    GoRoute(
      path: "collection/:id",
      pageBuilder: (c, s) => MaterialPage(
        key: ValueKey("collection/${s.params["id"]}"),
        child: MediaGroupScreen(
          id: s.params["id"]!,
          title: s.queryParams["title"] ?? "",
          query: ApiProvider.server.getCollection,
        ),
      ),
    ),
    GoRoute(
      path: "/genre/:id",
      pageBuilder: (c, s) => MaterialPage(
        key: ValueKey("genre/${s.params["id"]}"),
        child: MediaGroupScreen(
          id: s.params["id"]!,
          title: s.queryParams["title"] ?? "",
          query: ApiProvider.server.getGenre,
        ),
      ),
    ),
    GoRoute(
      path: "/audiobook/:id",
      pageBuilder: (c, s) => MaterialPage(
        key: ValueKey("audiobook/${s.params["id"]}"),
        child: AudioBookScreen(s.params["id"]!),
      ),
    ),
  ],
  errorPageBuilder: (context, route) => MaterialPage(
    child: UnknownRouteScreen(route: route),
  ),
);

class AppRouter extends StatelessWidget {
  const AppRouter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Router(
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
    );
  }
}
