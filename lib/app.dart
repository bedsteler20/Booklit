// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:plexlit_api/plexlit_api.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:plexlit/controllers/app_controllor.dart';
import 'package:plexlit/helpers/context.dart';
import 'package:plexlit/providers/api_provider.dart';
import 'package:plexlit/routes.dart';
import 'package:plexlit/service/audio_player.dart';
import 'package:plexlit/theme/google_theme.dart';
import 'package:plexlit/widgets/miniplayer.dart';
import 'package:plexlit/widgets/navbar.dart';

final _navBarKey = GlobalKey();

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: GThemeGenerator.generateDark(),
      home: const AppLayout(),
    );
  }
}

class AppLayout extends StatefulWidget {
  const AppLayout({Key? key}) : super(key: key);

  @override
  _AppLayoutState createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  NavigationType navigationTypeResolver(BuildContext context) {
    if (MediaQuery.of(context).size.width > 600) {
      return NavigationType.rail;
    } else {
      return NavigationType.bottom;
    }
  }

  onDestinationSelected(int i) {
    if (i == 0) router.currentState?.pushReplacementNamed("/");
    if (i == 1) router.currentState?.pushReplacementNamed("/library");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApiProvider>(builder: (context, _, __) {
      return Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(left: context.isSmallTablet ? 80 : 0),
              child: AppRouter(),
            ),
            if (context.isSmallTablet)
              Navbar(
                direction: Axis.vertical,
                key: _navBarKey,
              ),

            ValueListenableBuilder<Audiobook?>(
              valueListenable: context.read<AudioPlayerService>().current,
              builder: (context, audiobook, _) {
                if (audiobook == null) return const SizedBox();
                return Miniplayer(
                  valueNotifier: context.find<AppController>().miniPlayerHeight,
                  controller: context.find<AppController>().miniplayerController,
                  minHeight: 80,
                  maxHeight: context.height,
                  builder: (height, percentage) => MiniplayerWidget(
                    height: height,
                    percentage: percentage,
                  ),
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: context.isSmallTablet
            ? null
            : Navbar(
                direction: Axis.horizontal,
                key: _navBarKey,
              ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    context.find<AppController>().addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    context.find<AppController>().removeListener(() => setState(() {}));
  }
}

const _allDestinations = [
  AdaptiveScaffoldDestination(title: 'Home', icon: Icons.home_outlined),
  AdaptiveScaffoldDestination(title: 'Library', icon: Icons.library_books_outlined),
];
