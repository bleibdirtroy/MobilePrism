import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobileprism/constants/spacing.dart';
import 'package:mobileprism/services/controller/data_controller.dart';
import 'package:mobileprism/services/rest_api/photo_format.dart';
import 'package:mobileprism/views/album_view.dart';
import 'package:mobileprism/widgets/photo_preview.dart';

class AlbumsView extends StatelessWidget {
  final _dataController = DataController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _dataController.getAlbums(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            final List<Map<String, dynamic>> albums = snapshot.data!;
            return GridView.builder(
              itemCount: albums.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: mainAxisSpacing,
                crossAxisSpacing: crossAxisSpacing,
              ),
              itemBuilder: (context, index) {
                final album = albums.elementAt(index);
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AlbumView(
                          title: album["Title"].toString(),
                          albumUid: album["UID"].toString(),
                        ),
                      ),
                    );
                  },
                  child: GridTile(
                      footer: GridTileBar(
                        backgroundColor: Colors.black54,
                        title: Text(album["Title"].toString()),
                      ),
                      child: PhotoPreview(
                        hash: album["Thumb"].toString(),
                      )),
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
