// Project imports:
import 'package:booklit/booklit.dart';
import 'package:booklit/middleware/bookmarks.dart';

class NewBookmarkDialog extends StatefulWidget {
  const NewBookmarkDialog({Key? key}) : super(key: key);

  @override
  State<NewBookmarkDialog> createState() => _NewBookmarkDialogState();

  static open(BuildContext context) {
    context.find<AudioProvider>().pause();
    showDialog(context: context, builder: (_) => const NewBookmarkDialog());
  }
}

class _NewBookmarkDialogState extends State<NewBookmarkDialog> {
  final TextEditingController _textFieldController = TextEditingController();
  String? valueText;

  @override
  Widget build(BuildContext context) {
    final player = context.find<AudioProvider>();

    return AlertDialog(
      title: const Text('Add Bookmark'),
      content: TextField(
        onChanged: (value) {
          setState(() {
            valueText = value;
          });
        },
        controller: _textFieldController,
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
        ),
        TextButton(
          child: const Text('Add'),
          onPressed: () {
            player.addBookmark(valueText);
            Navigator.pop(context);
            player.play();
          },
        ),
      ],
    );
  }
}
