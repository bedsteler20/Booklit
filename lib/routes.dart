// Flutter imports:

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:miniplayer/miniplayer.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:plexlit/helpers/context.dart';
import 'package:plexlit/modules/plex/plex_library_picker.dart';
import 'package:plexlit/modules/plex/plex_server_picker.dart';
import 'package:plexlit/providers/api_provider.dart';
import 'package:plexlit/screens/audiobook_screen.dart';
import 'package:plexlit/screens/auth_screen.dart';
import 'package:plexlit/screens/home_screen.dart';
import 'package:plexlit/screens/library_screen.dart';
import 'package:plexlit/screens/media_group_screen.dart';
import 'controllers/app_controllor.dart';

// Package imports:




final router = GlobalKey<NavigatorState>();
final routeName = ValueNotifier<String>("/");

class AppRouter extends StatelessWidget {
  const AppRouter({Key? key}) : super(key: key);

  Route onGenerateRoute(BuildContext context, RouteSettings settings) {
    var name = settings.name ?? "/404";
    var args = settings.arguments;

    if (name == "/plex/servers") {
      args as Map;
      routeName.value = name;

      return MaterialPageRoute(
        builder: (_) => PlexServerPicker(
          token: args["token"],
          clientId: args["clientId"],
        ),
      );
    }

    if (name == "/plex/librarys") {
      args as Map;
      routeName.value = name;

      return MaterialPageRoute(
        builder: (_) => PlexLibraryPicker(
          token: args["token"],
          clientId: args["clientId"],
          server: args["server"],
        ),
      );
    }

    if (name == "/login") {
      routeName.value = name;

      return MaterialPageRoute(builder: (_) => const AuthScreen());
    }

    if (context.read<ApiProvider>().value.value != null) {
      routeName.value = name;

      if (name == "/") return MaterialPageRoute(builder: (_) => const HomeScreen());

      if (name == "/library") return MaterialPageRoute(builder: (_) => const LibraryScreen());

      if (name == "/audiobook") {
        args as Map;
        return MaterialPageRoute(
          builder: (_) => AudioBookScreen(args['id']),
        );
      }

      if (name == "/collection") {
        args as Map;
        return MaterialPageRoute(
          builder: (_) => MediaGroupScreen(
            id: args['id'],
            query: context.find<ApiProvider>().server.getCollection,
            title: args['title'],
          ),
        );
      }

      if (name == "/genre") {
        args as Map;
        return MaterialPageRoute(
          builder: (_) => MediaGroupScreen(
            id: args['id'],
            query: context.find<ApiProvider>().server.getGenre,
            title: args['title'],
          ),
        );
      }
    } else {
      routeName.value = "/login";
      return MaterialPageRoute(builder: (_) => const AuthScreen());
    }

    return MaterialPageRoute(builder: (_) => const AuthScreen());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Stops back button from closing app
      onWillPop: () async => false,
      child: Navigator(
        key: router,
        initialRoute: '/',
        onGenerateRoute: (settings) => onGenerateRoute(context, settings),
        onPopPage: (route, _) {
          // Minimize Miniplayer when it is fully opened
          var miniplayer = context.find<AppController>().miniplayerController;
          if (miniplayer.value!.height > context.height * 0.7) {
            miniplayer.animateToHeight(
              state: PanelState.MIN,
              duration: const Duration(milliseconds: 200),
            );
            return false;
          }
          return true;
        },
      ),
    );
  }
}
