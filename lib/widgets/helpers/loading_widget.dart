import 'package:plexlit/plexlit.dart';
// Flutter imports:
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
    this.center = false,
    this.showLabel = true,
  }) : super(key: key);

  final bool center;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: center ? MainAxisSize.min : MainAxisSize.max,
      children: [
        const CircularProgressIndicator(),
        if (showLabel) const Text("Loading"),
      ],
    );
  }
}
