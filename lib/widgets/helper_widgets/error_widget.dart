// Flutter imports:
import 'package:flutter/material.dart';

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({this.error, Key? key}) : super(key: key);

  final Object? error;


  String get errorMessage {
    switch (error) {
      default:
        return "A Unknown Error Occurred";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.error,size: 48),
        Text(errorMessage)
      ],
    );
  }
}
