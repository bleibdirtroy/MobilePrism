import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobileprism/services/controller/data_controller.dart';

class PhotoPreview extends StatelessWidget {
  PhotoPreview({
    Key? key,
    required this.hash,
  }) : super(key: key);

  final DataController _dataController = DataController();
  final String hash;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      cacheKey: hash,
      imageUrl: _dataController.getPreviewPhotoUrl(hash),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      fit: BoxFit.cover,
    );
  }
}
