import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobileprism/services/controller/data_controller.dart';
import 'package:mobileprism/services/database/photo_data_entry.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageView extends StatefulWidget {
  final int? month;
  final int? year;
  final String? albumUid;
  final int index;

  const ImageView({required this.index, this.month, this.year, this.albumUid});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView>
    with SingleTickerProviderStateMixin {
  bool _visible = true;
  late final AnimationController _animationController;
  late final PageController _pageController;
  final dataController = DataController();

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

  Future<List<PhotoDataEntry>> getPhotos() async {
    if (widget.month != null && widget.year != null) {
      return dataController.getPhotosByMonthAndYear(
        widget.month!,
        widget.year!,
      );
    } else {
      throw Exception();
    }
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
        child: FutureBuilder(
          future: getPhotos(),
          builder: (context, AsyncSnapshot<List<PhotoDataEntry>> snapshot) {
            if (snapshot.hasData) {
              return PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                pageController: _pageController,
                itemCount: snapshot.data!.length,
                builder: (context, index) {
                  return PhotoViewGalleryPageOptions(
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 8,
                    imageProvider: CachedNetworkImageProvider(
                      "https://demo-de.photoprism.app/api/v1/t/${snapshot.data!.elementAt(index).imageHash}/public/${snapshot.data!.elementAt(index).imageQuality}",
                    ),
                    onTapUp: (context, details, controllerValue) {
                      setState(() {
                        _visible = !_visible;
                      });
                    },
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
