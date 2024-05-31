import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Thumbnail extends StatelessWidget {
  final String name, imgUrl;
  final bool isVideo;
  const Thumbnail(
      {super.key,
      required this.imgUrl,
      required this.isVideo,
      required this.name});

  @override
  Widget build(BuildContext context) {
    return isVideo
        ? Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 80,
            width: 80,
            child: CachedNetworkImage(
              imageUrl: imgUrl,
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          )
        : Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: CachedNetworkImage(
              imageUrl: imgUrl,
              width: 80,
              height: 80,
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          );
  }
}
