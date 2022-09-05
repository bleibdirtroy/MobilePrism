import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobileprism/models/photo_data_entry.dart';
import 'package:mobileprism/services/controller/data_controller.dart';
import 'package:mobileprism/widgets/list_of_photos.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class TimelineView extends StatefulWidget {
  @override
  State<TimelineView> createState() => _TimelineViewState();
}

class _TimelineViewState extends State<TimelineView> {
  final dataController = DataController();

  final ScrollController _scrollController = ScrollController();

  Future<Map<int, SplayTreeSet<int>>> getYearsAndMonth() {
    final data = dataController.getOccupiedDates();
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getYearsAndMonth(),
      builder: (
        context,
        AsyncSnapshot<Map<int, SplayTreeSet<int>>> snapshot,
      ) {
        if (snapshot.hasData) {
          final years = snapshot.data!.keys.toList()
            ..sort((a, b) => b.compareTo(a));
          return ListView.builder(
            cacheExtent: 10000,
            controller: _scrollController,
            itemCount: years.length,
            itemBuilder: (context, index) {
              final year = years.elementAt(index);
              final months = snapshot.data![year]!.toList()
                ..sort((a, b) => b.compareTo(a));
              return Column(
                children: months
                    .map(
                      (month) => TitleWithPhotosByMonthAndYear(
                        year: year,
                        month: month,
                      ),
                    )
                    .toList(),
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class TitleWithPhotosByMonthAndYear extends StatelessWidget {
  final dataController = DataController();
  final int year;
  final int month;

  TitleWithPhotosByMonthAndYear({
    super.key,
    required this.year,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
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
      content: FutureBuilder(
        future: dataController.getPhotosOfMonthAndYear(
          DateTime(
            year,
            month,
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
}
