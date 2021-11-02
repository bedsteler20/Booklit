// Dart imports:
// ignore_for_file: non_constant_identifier_names

// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:booklit/screens/bookmarks_screen.dart';
import 'package:miniplayer/miniplayer.dart';

// Project imports:
import 'package:booklit/booklit.dart';
import 'package:booklit/widgets/audio_player/more_button.dart';
import 'package:booklit/widgets/dialogs/new_bookmark_dialog.dart';

class MiniplayerWidget extends StatelessWidget {
  const MiniplayerWidget({
    Key? key,
    required this.height,
    required this.percentage,
  }) : super(key: key);

  final double height;
  final double percentage;

  // Constants
  static const animationDuration = Duration(milliseconds: 10);
  static const imageConstraints = BoxConstraints(maxHeight: 500);

  // Styles

  // Calculations

  @override
  Widget build(BuildContext context) {
    var player = context.find<AudioProvider>();
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
              duration: animationDuration,
              child: Container(
                padding: EdgeInsets.only(top: percentage * 65),
                constraints: BoxConstraints(
                    maxHeight: height.clamp(0, context.height.clamp(0, context.height / 2.2))),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Thumb
                    AnimatedContainer(
                      duration: animationDuration,
                      padding: const EdgeInsets.all(5),
                      child: ImageWidget(
                        url: context.select<AudioProvider, Uri?>((v) => v.current?.thumb),
                        borderRadius: percentage < 0.3 ? 5 : 20,
                      ),
                    ),
                    // title/author
                    AnimatedOpacity(
                      duration: animationDuration,
                      opacity: textOpacity,
                      child: ColumnContainer(
                        width: lerpDouble(0, context.width * 0.75, (1 - percentage.clamp(0, 1))),
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        padding: const EdgeInsets.all(10),
                        children: [
                          Text(
                            context.select<AudioProvider, String>((v) => v.current!.title),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodyText1!.copyWith(fontSize: 20),
                          ),
                          Text(
                            context.select<AudioProvider, String>((v) => v.current!.author),
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
              offstage: percentage < 0.3,
              child: GestureDetector(
                onVerticalDragStart: (_) {},
                onVerticalDragUpdate: (_) {},
                child: Opacity(
                  opacity: percentage < 0.3 ? 0.0 : percentage,
                  child: AppBar(
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.list_rounded),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => const Dialog(
                              insetPadding: EdgeInsets.all(0),
                              child: BookmarksScreen(),
                            ),
                            useRootNavigator: true,
                          );
                        },
                      ),
                      IconButton(
                        onPressed: () => NewBookmarkDialog.open(context),
                        icon: const Icon(Icons.bookmark_add_rounded),
                      ),
                      const MiniplayerMoreButton(),
                    ],
                    title: Text(context.select<AudioProvider, String>((v) => v.current!.title)),
                    backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_drop_down),
                      onPressed: () => MINIPLAYER_CONTROLLER.animateToHeight(state: PanelState.MIN),
                    ),
                  ),
                ),
              ),
            ),
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
}
