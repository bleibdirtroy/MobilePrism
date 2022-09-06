import 'package:flutter/material.dart';
import 'package:mobileprism/constants/spacing.dart';
import 'package:mobileprism/models/photo_data_entry.dart';
import 'package:mobileprism/views/image_view.dart';
import 'package:mobileprism/widgets/photo_preview.dart';

class ListOfPhotos extends StatelessWidget {
  final List<PhotoDataEntry>? photos;

  const ListOfPhotos({
    this.photos,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
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
    );
  }
}
