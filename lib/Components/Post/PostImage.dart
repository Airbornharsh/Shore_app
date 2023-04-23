import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PostImage extends StatelessWidget {
  String postUrl;
  String postId;
  PostImage({super.key, required this.postUrl, required this.postId});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      decoration: const BoxDecoration(color: Color.fromARGB(31, 165, 165, 165)),
      child: postUrl.isNotEmpty
          ? Hero(
              tag: postId,
              child: CachedNetworkImage(
                imageUrl: postUrl,
                filterQuality: FilterQuality.low,
                width: size.width,
                fit: BoxFit.cover,
                memCacheWidth: size.width.toInt(),
                progressIndicatorBuilder: (context, url, downloadProgress) {
                  return SizedBox(
                      height: size.width * 0.8,
                      width: size.width,
                      child: const Center(
                        child: CircularProgressIndicator.adaptive(),
                      ));
                },
                errorWidget: (context, url, error) => SizedBox(
                    width: size.width,
                    height: size.width,
                    child: Center(
                        child: Image.asset("lib/assets/images/error.png"))),
              ),
            )
          : null,
    );
  }
}
