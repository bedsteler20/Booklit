// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:miniplayer/miniplayer.dart';

// Project imports:
import 'package:plexlit/plexlit.dart';

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
    var player = context.find<AudioProvider>();
    double textOpacity = (1 - (percentage * 2)).clamp(0, 1);
    var alignment = Alignment.lerp(Alignment.bottomLeft, Alignment.topCenter, percentage)!;

    if (context.isTablet && context.isLandscape) return buildDesktop(context);

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
                padding: EdgeInsets.only(top: percentage * 65),
                constraints: BoxConstraints(
                    maxHeight: height.clamp(0, context.height.clamp(0, context.height / 2.2))),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Thumb
                    AnimatedContainer(
                      duration: animationDiration,
                      padding: const EdgeInsets.all(5),
                      child: ImageWidget(
                        url: context.select<AudioProvider, Uri?>((v) => v.current?.thumb),
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

  Widget buildDesktop(BuildContext context) {
    var player = context.find<AudioProvider>();
    double textOpacity = (1 - (percentage * 2)).clamp(0, 1);
    var alignment = Alignment.lerp(Alignment.bottomLeft, Alignment.topCenter, percentage)!;

    return GestureDetector(
      onPanStart: (_) {},
      onTap: () {},
      child: Container(
        width: context.width - 80,
        color: context.theme.cardColor,
        height: 80,
        child: Expanded(
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              Row(
                children: [
                  const Expanded(child: SizedBox()),
                  ColumnContainer(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          context.select<AudioProvider, String>((v) => v.chapter!.name),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodyText1!.copyWith(fontSize: 20),
                        ),
                      ),
                      const Timeline(
                        labelLocation: TimeLabelLocation.sides,
                      ),
                    ],
                    width: context.width * 0.4,
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(4.0),
                    child: ImageWidget(
                      url: context.select<AudioProvider, Uri?>((v) => v.current?.thumb),
                    ),
                  ),
                  const PlayButton(
                    desktop: true,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget appBarBuilder(BuildContext context, AudioProvider player) {
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
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        visualDensity: VisualDensity.compact,
                        leading: const Icon(Icons.book_rounded),
                        contentPadding: const EdgeInsets.all(2),
                        title: const Text("Chapter"),
                        onTap: () =>
                            showDialog(context: context, builder: (_) => const ChapterPicker()),
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        visualDensity: VisualDensity.compact,
                        leading: const Icon(Icons.stop_rounded),
                        contentPadding: const EdgeInsets.all(2),
                        title: const Text("Stop"),
                        onTap: () {
                          player.stop();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        visualDensity: VisualDensity.compact,
                        leading: const Icon(Icons.timer_rounded),
                        contentPadding: const EdgeInsets.all(2),
                        title: const Text("Sleep Timer"),
                        onTap: () {
                          Navigator.pop(context);
                          SleepTimerDialog.show(context);
                        },
                      ),
                    ),
                  ];
                },
              ),
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
    );
  }
}

class DesktopExpandMiniplayerButton extends StatefulWidget {
  const DesktopExpandMiniplayerButton({Key? key}) : super(key: key);

  @override
  _DesktopExpandMiniplayerButtonState createState() => _DesktopExpandMiniplayerButtonState();
}

class _DesktopExpandMiniplayerButtonState extends State<DesktopExpandMiniplayerButton> {
  bool isOpen = false;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() => isOpen = !isOpen);
      },
      icon: const Icon(Icons.keyboard_arrow_up_rounded),
    );
  }
}
