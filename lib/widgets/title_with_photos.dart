import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobileprism/constants/application.dart';
import 'package:mobileprism/constants/spacing.dart';
import 'package:mobileprism/services/database/photo_data_entry.dart';
import 'package:mobileprism/services/rest_api/photo_format.dart';
import 'package:mobileprism/services/rest_api/rest_api_service.dart';
import 'package:mobileprism/views/image_view.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class TitleWithPhotos extends StatelessWidget {
  final restApiService = RestApiService(photoprimDefaultServer);

  final String title;
  final List<PhotoDataEntry>? photos;
  final String? albumUid;
  final DateTime? currentDate;

  TitleWithPhotos({
    required this.title,
    this.photos,
    this.albumUid,
    this.currentDate,
  });

  @override
  Widget build(BuildContext context) {
    return StickyHeader(
      header: Container(
        height: 50.0,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .headline4!
              .apply(fontFamily: "Questrial"),
        ),
      ),
      content: photos != null
          ? GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: photos!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: mainAxisSpacing,
                crossAxisSpacing: crossAxisSpacing,
              ),
              itemBuilder: (contxt, imageIndex) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          if (currentDate != null) {
                            return ImageView(
                              index: imageIndex,
                              photos: photos!,
                            );
                          } else {
                            return const Center(
                              child: Text("NOT IMPLEMENTED"),
                            );
                          }
                        },
                      ),
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: restApiService
                        .buildPhotoUrl(
                          hash: photos![imageIndex].imageHash!,
                          photoFormat: PhotoFormat.tile_100,
                        )
                        .toString(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                );
              },
            )
          : FutureBuilder(
              future:
                  restApiService.getPhotos(count: 99999999, albumUid: albumUid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container();
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
