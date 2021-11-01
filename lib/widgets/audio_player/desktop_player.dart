import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:booklit/booklit.dart';
import 'package:booklit/widgets/audio_player/more_button.dart';

class DesktopMiniplayer extends StatelessWidget {
  const DesktopMiniplayer({    Key? key,
    required this.height,
    required this.percentage,
  }) : super(key: key);

  final double height;
  final double percentage;

  @override
  Widget build(BuildContext context) {
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
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  padding: const EdgeInsets.all(4.0),
                  child: ImageWidget(
                    url: context.select<AudioProvider, Uri?>((v) => v.current?.thumb),
                  ),
                ),
                const PlayButton(desktop: true),
              ],
            ),
            const Expanded(child: SizedBox()),
            Row(
              children: [
                const SeekButton(time: -30, desktop: true),
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
                const SeekButton(time: 30, desktop: true),
              ],
            ),
            const Expanded(child: SizedBox()),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(4.0),
              child: const MiniplayerMoreButton(),
            ),
          ],
        ),
      ),
    );
  }
}