import 'dart:collection';

import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:mobileprism/services/controller/data_controller.dart';
import 'package:mobileprism/widgets/text_scroll_view.dart';
import 'package:mobileprism/widgets/title_with_fotos_by_month_and_year.dart';

class TimelineView extends StatefulWidget {
  @override
  State<TimelineView> createState() => _TimelineViewState();
}

class _TimelineViewState extends State<TimelineView> {
  final dataController = DataController();
  final ScrollController _scrollController = ScrollController();
  Map<int, SplayTreeSet<int>> occupiedDates = {};
  List<int> availableYears = [];
  int progressMax = 0;
  int progressCurrent = 0;

  void getYearsAndMonth() {
    occupiedDates = dataController.getOccupiedDates();
    availableYears = occupiedDates.keys.toList()
      ..sort((a, b) => b.compareTo(a));
  }

  Future<void> preloadTimeline() async {
    final dates = await dataController.updateOccupiedDates();
    final futures = <Future>[];

    dates.forEach((year, months) async {
      for (final month in months) {
        futures.add(
          dataController.updatePhotosOfMonthAndYear(
            DateTime(
              year,
              month,
            ),
          ),
        );
      }
    });
    await Future.wait(futures).then((value) {
      setState(() {
        getYearsAndMonth();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preload finished'),
        ),
      );
    });
  }

  @override
  void initState() {
    getYearsAndMonth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          return preloadTimeline();
        },
        child: availableYears.isNotEmpty
            ? DraggableScrollbar.semicircle(
                controller: _scrollController,
                child: ListView.builder(
                  cacheExtent: 500,
                  controller: _scrollController,
                  itemCount: availableYears.length,
                  itemBuilder: (context, index) {
                    final year = availableYears.elementAt(index);
                    final months = occupiedDates[year]!.toList()
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
                ),
              )
            : const TextScrollView(
                text: "No Photos loaded. Pull down",
              ),
      ),
    );
  }
}
