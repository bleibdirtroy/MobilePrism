import 'package:flutter/material.dart';
import 'package:mobileprism/constants/spacing.dart';
import 'package:mobileprism/models/album_data_entry.dart';
import 'package:mobileprism/models/photo_data_entry.dart';
import 'package:mobileprism/services/controller/data_controller.dart';
import 'package:mobileprism/views/image_view.dart';
import 'package:mobileprism/widgets/photo_preview.dart';
import 'package:mobileprism/widgets/text_scroll_view.dart';

class AlbumView extends StatefulWidget {
  const AlbumView(this.album);
  final AlbumDataEntry album;

  @override
  State<AlbumView> createState() => _AlbumViewState();
}

class _AlbumViewState extends State<AlbumView> {
  final _dataController = DataController();
  List<PhotoDataEntry> photos = [];

  Future<void> updatePhotos() async {
    photos = await _dataController.updatePhotosOfAlbum(widget.album.uid);
    setState(() {});
  }

  @override
  void initState() {
    photos = _dataController.getPhotosOfAlbum(widget.album.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.album.title)),
      body: RefreshIndicator(
        onRefresh: () {
          return updatePhotos();
        },
        child: photos.isNotEmpty
            ? GridView.builder(
                itemCount: photos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: mainAxisSpacing,
                  crossAxisSpacing: crossAxisSpacing,
                ),
                itemBuilder: (contxt, imageIndex) {
                  final photo = photos.elementAt(imageIndex);
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              ImageView(index: imageIndex, photos: photos),
                        ),
                      );
                    },
                    child: PhotoPreview(hash: photo.imageHash!),
                  );
                },
              )
            : const TextScrollView(text: "No Photos loaded. Pull down"),
      ),
    );
  }
}
