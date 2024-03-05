import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

const assetNoImage = 'assets/images/noimage.jpg';

class PersonCacheImage extends StatelessWidget {
  final String? imageUrl;
  final double width, height;

  const PersonCacheImage({
    required this.imageUrl,
    required this.width,
    required this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: width,
      height: height,
      imageUrl: imageUrl ?? '',
      imageBuilder: (context, imageProvider) =>
          _ImageWigdet(imageProvider: imageProvider),
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => const _ImageWigdet(
        imageProvider: AssetImage(assetNoImage),
      ),
    );
  }
}

class _ImageWigdet extends StatelessWidget {
  final ImageProvider imageProvider;

  const _ImageWigdet({
    required this.imageProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(8), topLeft: Radius.circular(8)),
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
