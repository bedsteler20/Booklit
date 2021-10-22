// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:miniplayer/miniplayer.dart';
import 'package:provider/src/provider.dart';

// Project imports:
import 'package:plexlit/plexlit.dart';
import 'miniplayer.dart';
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
                controller: miniplayerController,
                minHeight: 80,
                maxHeight: context.height,
                builder: (height, percentage) => MiniplayerWidget(
                  height: height,
                  percentage: percentage,
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: context.isTablet ? null : const Navbar(),
    );
  }
}
