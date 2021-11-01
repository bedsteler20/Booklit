// Project imports:
import 'package:booklit/booklit.dart';

Future<T?> showConfirmDialog<T>({
  required BuildContext context,
  String title = "Are you sure?",
  String cancelMessage = "No",
  String confirmMessage = "Yes",
  VoidCallback? onCanceled,
  VoidCallback? onConfirm,
}) =>
    showDialog(
        context: context,
        builder: (context) => ConfirmDialog(
              cancelMessage: cancelMessage,
              confirmMessage: confirmMessage,
              onCanceled: onConfirm,
              onConfirm: onConfirm,
              title: title,
            ));

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    Key? key,
    this.title = "Are you sure?",
    this.cancelMessage = "No",
    this.confirmMessage = "Yes",
    this.onCanceled,
    this.onConfirm,
  }) : super(key: key);
  final VoidCallback? onCanceled;
  final VoidCallback? onConfirm;
  final String confirmMessage;
  final String cancelMessage;
  final String title;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onCanceled?.call();
          },
          child: Text(cancelMessage),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm?.call();
          },
          child: Text(confirmMessage),
        )
      ],
    );
  }
}
