import 'package:flutter/material.dart';
import 'package:mobileprism/widgets/sliding_app_bar.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageView extends StatefulWidget {
  const ImageView({Key? key}) : super(key: key);

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView>
    with SingleTickerProviderStateMixin {
  bool _visible = true;
  int numberOfPictures = 3;
  late final AnimationController _animationController;
  late final PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: 1);
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
      appBar: SlidingAppBar(
        controller: _animationController,
        visible: _visible,
        child: AppBar(),
      ),
      body: Dismissible(
        direction: DismissDirection.down,
        onDismissed: (direction) {
          Navigator.of(context).pop();
        },
        key: const Key('key'),
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          pageController: _pageController,
          itemCount: numberOfPictures,
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 8,
              imageProvider: const AssetImage("assets/images/large.jpg"),
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
