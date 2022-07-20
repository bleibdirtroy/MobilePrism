import 'package:flutter/material.dart';
import 'package:mobileprism/widgets/sliding_app_bar.dart';
import 'package:photo_view/photo_view.dart';

class ImageView extends StatefulWidget {
  const ImageView({Key? key}) : super(key: key);

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView>
    with SingleTickerProviderStateMixin {
  bool _visible = true;
  late final AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SlidingAppBar(
        controller: _controller,
        visible: _visible,
        child: AppBar(),
      ),
      body: Center(
        child: PhotoView(
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 8,
          imageProvider: const AssetImage("assets/images/large.jpg"),
          onTapUp: (context, details, controllerValue) {
            print("HI");
            setState(() {
              _visible = !_visible;
            });
          },
        ),
      ),
    );
  }
}
