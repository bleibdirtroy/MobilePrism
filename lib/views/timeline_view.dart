import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobileprism/constants/spacing.dart';
import 'package:mobileprism/services/controller/data_controller.dart';
import 'package:mobileprism/services/database/photo_data_entry.dart';
import 'package:mobileprism/services/rest_api/photo_format.dart';
import 'package:mobileprism/services/rest_api/rest_api_service.dart';
import 'package:mobileprism/views/image_view.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class TimelineView extends StatefulWidget {
  const TimelineView({Key? key}) : super(key: key);

  @override
  State<TimelineView> createState() => _TimelineViewState();
}

class _TimelineViewState extends State<TimelineView> {
  final dataController = DataController();
  final restApiService = RestApiService("https://demo-de.photoprism.app");
  int numberOfMonths = 0;

  Future<Map<int, SplayTreeSet<int>>> getYearsAndMonth() {
    final data = dataController.getAvailableYearsAndMonths();
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
                  return StickyHeader(
                    header: Container(
                      height: 50.0,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        DateFormat('MMMM yyyy')
                            .format(
                              DateTime(
                                year,
                                months.elementAt(monthIndex),
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
                      future: dataController.getPhotosByMonthAndYear(
                        months.elementAt(monthIndex),
                        years.elementAt(yearIndex),
                      ),
                      builder: (
                        context,
                        AsyncSnapshot<List<PhotoDataEntry>> snapshot,
                      ) {
                        if (snapshot.hasData) {
                          final photos = snapshot.data!;
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: photos.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              mainAxisSpacing: mainAxisSpacing,
                              crossAxisSpacing: crossAxisSpacing,
                            ),
                            itemBuilder: (contxt, imageIndex) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ImageView(
                                        index: imageIndex,
                                        month: months.elementAt(monthIndex),
                                        year: years.elementAt(yearIndex),
                                      ),
                                    ),
                                  );
                                },
                                child: CachedNetworkImage(
                                  imageUrl: restApiService
                                      .buildPhotoUrl(
                                        hash: photos[imageIndex].imageHash!,
                                        photoFormat: PhotoFormat.tile_100,
                                      )
                                      .toString(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  fit: BoxFit.cover,
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
