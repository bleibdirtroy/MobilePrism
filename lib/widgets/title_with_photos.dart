import 'package:flutter/material.dart';
import 'package:mobileprism/constants/spacing.dart';
import 'package:mobileprism/services/database/photo_data_entry.dart';
import 'package:mobileprism/views/image_view.dart';
import 'package:mobileprism/widgets/photo_preview.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class TitleWithPhotos extends StatelessWidget {
  final String title;
  final List<PhotoDataEntry>? photos;

  const TitleWithPhotos({
    required this.title,
    this.photos,
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
      content: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: photos!.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
        ),
        itemBuilder: (contxt, imageIndex) {
          final photo = photos!.elementAt(imageIndex);
          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ImageView(
                    index: imageIndex,
                    photos: photos!,
                  ),
                ),
              );
            },
            child: PhotoPreview(hash: photo.imageHash!),
          );
        },
      ),
    );
  }
}
