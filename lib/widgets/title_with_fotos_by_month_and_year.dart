import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobileprism/services/controller/data_controller.dart';
import 'package:mobileprism/widgets/list_of_photos.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class TitleWithPhotosByMonthAndYear extends StatelessWidget {
  final int year;
  final int month;

  TitleWithPhotosByMonthAndYear({
    super.key,
    required this.year,
    required this.month,
  });
  final dataController = DataController();

  @override
  Widget build(BuildContext context) {
    final photos = dataController.getPhotosOfMonthAndYear(
      DateTime(
        year,
        month,
      ),
    );
    return StickyHeader(
      header: Container(
        height: 50.0,
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          DateFormat('MMMM yyyy')
              .format(
                DateTime(
                  year,
                  month,
                ),
              )
              .toUpperCase(),
          style: Theme.of(context)
              .textTheme
              .headline4!
              .apply(fontFamily: "Questrial"),
        ),
      ),
      content: ListOfPhotos(
        photos: photos,
      ),
    );
  }
}
