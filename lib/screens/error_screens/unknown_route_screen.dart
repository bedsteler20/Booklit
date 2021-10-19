import 'package:plexlit/plexlit.dart';
// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

class UnknownRouteScreen extends StatelessWidget {
  const UnknownRouteScreen({Key? key, required this.route}) : super(key: key);

  final GoRouterState route;

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Unknown Route"),
    );
  }
}
