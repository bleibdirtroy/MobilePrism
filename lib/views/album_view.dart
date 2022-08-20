import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobileprism/constants/application.dart';
import 'package:mobileprism/constants/spacing.dart';
import 'package:mobileprism/services/controller/data_controller.dart';
import 'package:mobileprism/services/database/photo_data_entry.dart';
import 'package:mobileprism/services/rest_api/photo_format.dart';
import 'package:mobileprism/services/rest_api/rest_api_service.dart';
import 'package:mobileprism/views/image_view.dart';

class AlbumView extends StatelessWidget {
  AlbumView({required this.title, required this.albumUid});
  final _dataController = DataController();
  final _restApiService = RestApiService(photoprimDefaultServer);
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
            return GridView.builder(
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
                  child: CachedNetworkImage(
                    imageUrl: _restApiService
                        .buildPhotoUrl(
                          hash: photo.imageHash!,
                          photoFormat: PhotoFormat.tile_100,
                        )
                        .toString(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
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
    );
  }
}
