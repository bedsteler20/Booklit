import 'package:plexlit/plexlit.dart';

/// Buttons, Timeline & title widget
class AudioPlayerControls extends StatelessWidget {
  const AudioPlayerControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Builder(builder: title),
        Container(
          padding: const EdgeInsets.only(bottom: 15),
          width: MediaQuery.of(context).size.width * 0.8,
          child: const Timeline(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: const [
            SeekButton(time: -30),
            PlayButton(),
            SeekButton(time: 30),
          ],
        ),
      ],
    );
  }

  Widget title(BuildContext context) {
    final player = context.find<AudioProvider>();
    var name = context.select<AudioProvider, String?>((v) => v.chapter?.name);
    return Container(
      width: context.width * 0.8,
      padding: const EdgeInsets.only(top: 50, bottom: 25),
      child: Center(
        child: Text(
          name ?? "Chapter Null",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: context.bodyText1!.copyWith(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
