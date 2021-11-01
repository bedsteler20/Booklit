// Flutter imports:
import 'package:booklit/plexlit.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:miniplayer/miniplayer.dart';
import 'package:provider/src/provider.dart';

// Project imports:
import 'package:booklit/booklit.dart';
import 'audio_player/miniplayer.dart';
import 'navbar.dart';

// Project imports:

class AppScaffold extends StatefulWidget {
  const AppScaffold(this.child, {Key? key}) : super(key: key);
  final Widget child;

  @override
  _AppScaffoldState createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  @override
  Widget build(BuildContext context) {
    bool showMiniPlayer = context.select<AudioProvider, bool>((v) => v.current != null);
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: context.isTablet ? 80 : 0,
              bottom: showMiniPlayer ? 80 : 0,
            ),
            child: widget.child,
          ),
          if (context.isTablet)
            const Navbar(
              direction: Axis.vertical,
            ),
          if (showMiniPlayer)
            Padding(
              padding: EdgeInsets.only(left: context.isTablet ? 80 : 0),
              child: Miniplayer(
                controller: MINIPLAYER_CONTROLLER,
                minHeight: 80,
                maxHeight: context.height,
                builder: (height, percentage) {
                  if (context.isTablet && context.isLandscape) {
                    return MiniplayerWidget(
                      height: height,
                      percentage: percentage,
                    );
                  } else {
                    return DesktopMiniplayer(
                      height: height,
                      percentage: percentage,
                    );
                  }
                },
              ),
            ),
        ],
      ),
      bottomNavigationBar: context.isTablet ? null : const Navbar(),
    );
  }
}
