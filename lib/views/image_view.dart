import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobileprism/services/database/photo_data_entry.dart';
import 'package:mobileprism/services/rest_api/photo_format.dart';
import 'package:mobileprism/services/rest_api/rest_api_service.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageView extends StatefulWidget {
  final int index;
  final List<PhotoDataEntry> photos;

  const ImageView({required this.index, required this.photos});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView>
    with SingleTickerProviderStateMixin {
  bool _visible = true;
  late final AnimationController _animationController;
  late final PageController _pageController;
  final _restApiService = RestApiService();

  @override
  void initState() {
    _pageController = PageController(initialPage: widget.index);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _visible ? AppBar() : null,
      body: Dismissible(
        direction: DismissDirection.down,
        onDismissed: (direction) {
          Navigator.of(context).pop();
        },
        key: const Key('key'),
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          pageController: _pageController,
          itemCount: widget.photos.length,
          builder: (context, index) {
            final photo = widget.photos.elementAt(index);
            return PhotoViewGalleryPageOptions(
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 8,
              imageProvider: CachedNetworkImageProvider(
                _restApiService
                    .buildPhotoUrl(
                      hash: photo.imageHash!,
                      photoFormat: PhotoFormat.fit_7680,
                    )
                    .toString(),
              ),
              onTapUp: (context, details, controllerValue) {
                setState(() {
                  _visible = !_visible;
                });
              },
            );
          },
        ),
      ),
    );
  }
}
