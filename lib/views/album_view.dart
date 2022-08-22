import 'package:flutter/material.dart';
import 'package:mobileprism/constants/spacing.dart';
import 'package:mobileprism/services/controller/data_controller.dart';
import 'package:mobileprism/services/database/photo_data_entry.dart';
import 'package:mobileprism/views/image_view.dart';
import 'package:mobileprism/widgets/photo_preview.dart';

class AlbumView extends StatelessWidget {
  AlbumView({required this.title, required this.albumUid});
  final _dataController = DataController();
  final String title;
  final String albumUid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: FutureBuilder(
        future: _dataController.getPhotosOfAlbum(albumUid),
        builder: (context, AsyncSnapshot<List<PhotoDataEntry>> snapshot) {
          if (snapshot.hasData) {
            final photos = snapshot.data!;
            return photos.isNotEmpty
                ? GridView.builder(
                    itemCount: photos.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                : const Center(
                    child: Text("No photos in album"),
                  );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
