// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:plexlit/helpers/context.dart';
import 'package:plexlit/plexlit.dart';

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

  Widget buildLoading(BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
    if (loadingProgress == null) {
      return child;
    } else {
      return Shimmr();
    }
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
        color: context.theme.cardColor,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            height: width,
            width: height,
            child: Icon(icon, size: 36),
          ),
        ),
      );
    }
    if (url!.isScheme("https") || url!.isScheme("http")) {
      return Container(
        constraints: BoxConstraints(
          maxHeight: height ?? double.infinity,
          maxWidth: width ?? double.infinity,
        ),
        child: Image.network(
          url.toString(),
          height: height,
          width: width,
          loadingBuilder: buildLoading,
          errorBuilder: (ctx, e, stack) => Builder(builder: buildError),
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(borderRadius),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: child,
                ),
              ),
            );
          },
        ),
      );
    } else {
      return Container(
        constraints: BoxConstraints(
          maxHeight: height ?? double.infinity,
          maxWidth: width ?? double.infinity,
        ),
        child: Image.file(
          File(url!.path),
          errorBuilder: (ctx, e, stack) => Builder(builder: buildError),
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(borderRadius),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: child,
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
