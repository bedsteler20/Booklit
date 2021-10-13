// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    this.url,
    Key? key,
    this.width,
    this.height,
    this.transcode = false,
    this.borderRadius = 8.0,
    this.elevation = 10,
    this.asspectRatio = 1,
    this.icon,
  }) : super(key: key);

  final Uri? url;
  final bool transcode;
  final double? width;
  final double? height;
  final double elevation;
  final double borderRadius;
  final double asspectRatio;
  final IconData? icon;


  Widget buildError(BuildContext context) {
    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      child: const Icon(
        Icons.error_outline,
        color: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (icon == null && url == null) {
      return Builder(
        builder: buildError,
      );
    }

    if (icon != null) {
      return Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: SizedBox(
            height: width,
            width: height,
            child: Icon(icon, size: 36),
          ),
        ),
      );
    }
    return Image.network(
      url.toString(),
      height: height,
      width: width,
      errorBuilder: (ctx, e, stack) => Builder(builder: buildError),
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        return Material(
          elevation: elevation,
          borderRadius: BorderRadius.circular(borderRadius),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: child,
          ),
        );
      },
    );
  }
}
