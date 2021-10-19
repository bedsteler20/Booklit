// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:miniplayer/miniplayer.dart';
import 'package:plexlit/model/model.dart';
import 'package:provider/src/provider.dart';

// Project imports:
import 'package:plexlit/globals.dart';
import 'package:plexlit/helpers/context.dart';
import 'package:plexlit/service/audio_player.dart';
import 'miniplayer.dart';
import 'navbar.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold(this.child, {Key? key}) : super(key: key);
  final Widget child;
  @override
  _AppScaffoldState createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: context.isSmallTablet ? 80 : 0),
            child: widget.child,
          ),
          if (context.isTablet)
            const Navbar(
              direction: Axis.vertical,
            ),
          Padding(
            padding: EdgeInsets.only(left: context.isTablet ? 80 : 0),
            child: ValueListenableBuilder<Audiobook?>(
              valueListenable: context.read<AudioPlayerService>().current,
              builder: (context, audiobook, _) {
                if (audiobook == null) return const SizedBox();
                return Miniplayer(
                  controller: miniplayerController,
                  minHeight: 80,
                  maxHeight: context.height,
                  builder: (height, percentage) => MiniplayerWidget(
                    height: height,
                    percentage: percentage,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: context.isTablet ? null : const Navbar(),
    );
  }
}
