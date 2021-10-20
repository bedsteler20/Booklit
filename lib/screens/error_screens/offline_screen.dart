// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:vrouter/src/core/extended_context.dart';

// Project imports:
import 'package:plexlit/helpers/context.dart';
import 'package:plexlit/plexlit.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.wifi_off_rounded, size: 100),
        Text("No Internet", style: context.headline6),
      ],
    );
  }
}
