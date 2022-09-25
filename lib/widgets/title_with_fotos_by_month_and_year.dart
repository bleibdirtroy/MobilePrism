import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobileprism/models/photo_data_entry.dart';
import 'package:mobileprism/services/controller/data_controller.dart';
import 'package:mobileprism/widgets/list_of_photos.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class TitleWithPhotosByMonthAndYear extends StatefulWidget {
  final int year;
  final int month;

  const TitleWithPhotosByMonthAndYear({
    super.key,
    required this.year,
    required this.month,
  });

  @override
  State<TitleWithPhotosByMonthAndYear> createState() =>
      _TitleWithPhotosByMonthAndYearState();
}

class _TitleWithPhotosByMonthAndYearState
    extends State<TitleWithPhotosByMonthAndYear>
    with AutomaticKeepAliveClientMixin {
  final dataController = DataController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                  widget.year,
                  widget.month,
                ),
              )
              .toUpperCase(),
          style: Theme.of(context)
              .textTheme
              .headline4!
              .apply(fontFamily: "Questrial"),
        ),
      ),
      content: FutureBuilder(
        future: dataController.updatePhotosOfMonthAndYear(
          DateTime(
            widget.year,
            widget.month,
          ),
        ),
        builder: (
          context,
          AsyncSnapshot<List<PhotoDataEntry>> snapshot,
        ) {
          if (snapshot.hasData) {
            final photos = snapshot.data!;
            return ListOfPhotos(
              photos: photos,
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

  @override
  bool get wantKeepAlive => true;
}
