import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobileprism/services/controller/data_controller.dart';
import 'package:mobileprism/services/rest_api/rest_api_service.dart';

class PhotoPreview extends StatelessWidget {
  PhotoPreview({
    super.key,
    required this.hash,
  });

  final DataController _dataController = DataController();
  final String hash;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      cacheKey: "$hash/thumb",
      httpHeaders: RestApiService().getHeader(),
      imageUrl: _dataController.getPreviewPhotoUrl(hash),
      placeholder: (context, url) => Container(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      fit: BoxFit.cover,
    );
  }
}
