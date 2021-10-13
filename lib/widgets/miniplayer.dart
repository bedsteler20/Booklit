// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:build_context/build_context.dart';

// Project imports:
import 'package:plexlit/helpers/context.dart';
import 'package:plexlit/service/service.dart';
import 'audio_player/controlls.dart';
import 'flutter_helpers.dart';
import 'image_widget.dart';

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
      color: context.theme.bottomNavigationBarTheme.backgroundColor,
      children: [
        AnimatedAlign(
          alignment: alignment,
          duration: animationDiration,
          child: Container(
            constraints: BoxConstraints(maxHeight: height.clamp(0, context.height.clamp(0, context.height / 2.5))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Thumb
                Container(
                  padding: const EdgeInsets.all(10),
                  child: ImageWidget(
                    url: player.audioBook?.thumb,
                    borderRadius: 5,
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
                      Text(
                        player.audioBook!.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodyText1!.copyWith(fontSize: 20),
                      ),
                      Text(
                        player.audioBook!.author,
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
        Offstage(
          offstage: percentage == 0,
          child: GestureDetector(
            onVerticalDragStart: (_) {},
            onVerticalDragUpdate: (_) {},
            child: Opacity(
              opacity: percentage < 0.3 ? 0.0 : percentage,
              child: const AudioPlayerControlls(),
            ),
          ),
        ),
      ],
    );
  }
}
