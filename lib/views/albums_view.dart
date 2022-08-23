import 'package:flutter/material.dart';
import 'package:mobileprism/constants/spacing.dart';
import 'package:mobileprism/services/controller/data_controller.dart';
import 'package:mobileprism/services/database/album_data_entry.dart';
import 'package:mobileprism/views/album_view.dart';
import 'package:mobileprism/widgets/photo_preview.dart';

class AlbumsView extends StatelessWidget {
  final _dataController = DataController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _dataController.getAlbums(),
        builder: (context, AsyncSnapshot<List<AlbumDataEntry>> snapshot) {
          if (snapshot.hasData) {
            final List<AlbumDataEntry> albums = snapshot.data!;
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
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AlbumView(album),
                      ),
                    );
                  },
                  child: GridTile(
                    footer: GridTileBar(
                      backgroundColor: Colors.black54,
                      title: Text(album.title),
                    ),
                    child: album.thumbHash != ""
                        ? PhotoPreview(
                            hash: album.thumbHash,
                          )
                        : const Center(child: Icon(Icons.warning)),
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
