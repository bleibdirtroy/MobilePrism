import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobileprism/services/controller/data_controller.dart';
import 'package:mobileprism/services/database/photo_data_entry.dart';
import 'package:mobileprism/widgets/title_with_photos.dart';

class TimelineView extends StatefulWidget {
  const TimelineView({Key? key}) : super(key: key);

  @override
  State<TimelineView> createState() => _TimelineViewState();
}

class _TimelineViewState extends State<TimelineView> {
  final dataController = DataController();
  int numberOfMonths = 0;

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
            itemCount: years.length,
            itemBuilder: (context, yearIndex) {
              final year = years.elementAt(yearIndex);
              final months = snapshot.data![year]!;
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: months.length,
                itemBuilder: (context, monthIndex) {
                  return FutureBuilder(
                    future: dataController.getPhotosOfMonthAndYear(
                      DateTime(
                        years.elementAt(yearIndex),
                        months.elementAt(monthIndex),
                      ),
                    ),
                    builder: (
                      context,
                      AsyncSnapshot<List<PhotoDataEntry>> snapshot,
                    ) {
                      if (snapshot.hasData) {
                        final photos = snapshot.data!;
                        return TitleWithPhotos(
                          title: DateFormat('MMMM yyyy')
                              .format(
                                DateTime(
                                  year,
                                  months.elementAt(monthIndex),
                                ),
                              )
                              .toUpperCase(),
                          photos: photos,
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  );
                },
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
