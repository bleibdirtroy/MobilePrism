import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:mobileprism/services/controller/data_controller.dart';
import 'package:mobileprism/widgets/title_with_fotos_by_month_and_year.dart';

class TimelineView extends StatelessWidget {
  final dataController = DataController();
  final Map<int, Set<int>> test = {};

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
            cacheExtent: 500,
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
