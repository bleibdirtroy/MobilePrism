import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobileprism/constants/application.dart';
import 'package:mobileprism/constants/spacing.dart';
import 'package:mobileprism/services/controller/data_controller.dart';
import 'package:mobileprism/services/rest_api/photo_format.dart';
import 'package:mobileprism/services/rest_api/rest_api_service.dart';

class AlbumsView extends StatelessWidget {
  final _dataController = DataController();
  final _restApiService = RestApiService(photoprimDefaultServer);

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
                    log("album ${album['UID']} touched");
                  },
                  child: GridTile(
                    footer: GridTileBar(
                      backgroundColor: Colors.black54,
                      title: Text(album["Title"].toString()),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: _restApiService
                          .buildPhotoUrl(
                            hash: album["Thumb"].toString(),
                            photoFormat: PhotoFormat.tile_500,
                          )
                          .toString(),
                    ),
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
