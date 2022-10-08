import 'package:flutter/material.dart';
import 'package:mobileprism/constants/spacing.dart';
import 'package:mobileprism/models/album_data_entry.dart';
import 'package:mobileprism/services/controller/data_controller.dart';
import 'package:mobileprism/views/album_view.dart';
import 'package:mobileprism/widgets/photo_preview.dart';
import 'package:mobileprism/widgets/text_scroll_view.dart';

class AlbumsView extends StatefulWidget {
  @override
  State<AlbumsView> createState() => _AlbumsViewState();
}

class _AlbumsViewState extends State<AlbumsView> {
  final _dataController = DataController();
  List<AlbumDataEntry> albums = [];

  Future<void> updateAlbums() async {
    albums = await _dataController.updateAlbums();
    setState(() {});
  }

  @override
  void initState() {
    albums = _dataController.getAlbums();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          return updateAlbums();
        },
        child: albums.isNotEmpty
            ? GridView.builder(
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
              )
            : const TextScrollView(
                text: "No Albums loaded. Pull down",
              ),
      ),
    );
  }
}
