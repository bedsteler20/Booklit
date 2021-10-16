// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:miniplayer/miniplayer.dart';
import 'package:plexlit/model/model.dart';

// Project imports:
import 'package:plexlit/globals.dart';
import 'package:plexlit/helpers/context.dart';
import 'package:plexlit/service/service.dart';
import 'package:plexlit/widgets/dialogs/player_speed_dialog.dart';
import '../audio_player/controls.dart';
import '../helper_widgets/flutter_helpers.dart';
import '../helper_widgets/image_widget.dart';

// Package imports:

class MiniplayerWidget extends StatelessWidget {
  const MiniplayerWidget({
    Key? key,
    required this.height,
    required this.percentage,
  }) : super(key: key);

  final double height;
  final double percentage;

  // Constants
  static const animationDiration = Duration(milliseconds: 10);
  static const imageConstrants = BoxConstraints(maxHeight: 500);

  // Styles

  // Calculations

  @override
  Widget build(BuildContext context) {
    var player = context.find<AudioPlayerService>();
    double textOpacity = (1 - (percentage * 2)).clamp(0, 1);
    var alignment = Alignment.lerp(Alignment.bottomLeft, Alignment.topCenter, percentage)!;

    return ColumnContainer(
      constraints: BoxConstraints(maxHeight: height),
      color: context.theme.navigationBarTheme.backgroundColor,
      children: [
        Stack(
          children: [
            AnimatedAlign(
              alignment: alignment,
              duration: animationDiration,
              child: Container(
                padding: EdgeInsets.only(top: percentage * 45),
                constraints: BoxConstraints(
                    maxHeight: height.clamp(0, context.height.clamp(0, context.height / 2.2))),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Thumb
                    AnimatedContainer(
                      duration: animationDiration,
                      padding: const EdgeInsets.all(10),
                      child: ImageWidget(
                        url: player.current.value?.thumb,
                        borderRadius: percentage < 0.3 ? 5 : 20,
                      ),
                    ),
                    // title/author
                    AnimatedOpacity(
                      duration: animationDiration,
                      opacity: textOpacity,
                      child: ColumnContainer(
                        width: lerpDouble(0, context.width * 0.75, (1 - percentage.clamp(0, 1))),
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        padding: const EdgeInsets.all(10),
                        children: [
                          ValueListenableBuilder<Chapter?>(
                              valueListenable: player.chapter,
                              builder: (context, chapter, _) {
                                return Text(
                                  chapter?.name ?? player.current.value!.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.textTheme.bodyText1!.copyWith(fontSize: 20),
                                );
                              }),
                          Text(
                            player.current.value!.author,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.caption!.copyWith(fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            appBarBuilder(context, player),
          ],
        ),
        Offstage(
          offstage: percentage == 0,
          child: GestureDetector(
            onVerticalDragStart: (_) {},
            onVerticalDragUpdate: (_) {},
            child: Opacity(
              opacity: percentage < 0.3 ? 0.0 : percentage,
              child: const AudioPlayerControls(),
            ),
          ),
        ),
      ],
    );
  }

  Widget appBarBuilder(BuildContext context, AudioPlayerService player) {
    return Offstage(
      offstage: percentage < 0.3,
      child: GestureDetector(
        onVerticalDragStart: (_) {},
        onVerticalDragUpdate: (_) {},
        child: Opacity(
          opacity: percentage < 0.3 ? 0.0 : percentage,
          child: AppBar(
            actions: [
              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                color: context.theme.scaffoldBackgroundColor,
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: ListTile(
                        visualDensity: VisualDensity.compact,
                        leading: const Icon(Icons.speed_rounded),
                        contentPadding: const EdgeInsets.all(2),
                        title: const Text("Playback Speed"),
                        onTap: () =>
                            showDialog(context: context, builder: (_) => const PlayerSpeedDialog()),
                      ),
                    )
                  ];
                },
              ),
            ],
            title: Text(player.current.value!.title),
            backgroundColor: const Color.fromARGB(0, 0, 0, 0),
            leading: IconButton(
              icon: const Icon(Icons.arrow_drop_down),
              onPressed: () => miniPlayer.animateToHeight(state: PanelState.MIN),
            ),
          ),
        ),
      ),
    );
  }
}
