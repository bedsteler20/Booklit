// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:vrouter/vrouter.dart';

class BackButton extends StatelessWidget {
  const BackButton({Key? key, this.onTap}) : super(key: key);

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_rounded),
      onPressed: () {
        if (context.vRouter.historyCanBack()) {
          onTap?.call();
          context.vRouter.historyBack();
        }
      },
    );
  }
}
