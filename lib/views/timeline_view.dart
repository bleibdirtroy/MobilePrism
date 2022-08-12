import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobileprism/constants/spacing.dart';
import 'package:mobileprism/services/controller/data_controller.dart';
import 'package:mobileprism/views/image_view.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class TimelineView extends StatefulWidget {
  const TimelineView({Key? key}) : super(key: key);

  @override
  State<TimelineView> createState() => _TimelineViewState();
}

class _TimelineViewState extends State<TimelineView> {
  final dataController = DataController();
  int numberOfMonths = 0;

  Future<SplayTreeMap<int, SplayTreeSet<int>>> getYearsAndMonth() {
    final data = dataController.getAvailableYearsAndMonths();
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getYearsAndMonth(),
      builder: (
        context,
        AsyncSnapshot<SplayTreeMap<int, SplayTreeSet<int>>> snapshot,
      ) {
        if (snapshot.hasData) {
          int count = 0;
          for (final year in snapshot.data!.keys) {
            count += snapshot.data![year]!.length;
          }
          return ListView.builder(
            itemCount: count,
            itemBuilder: (context, yearIndex) {
              return StickyHeader(
                header: Container(
                  height: 50.0,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    DateFormat('MMMM yyyy')
                        // 12 - is just used to display the months in reverese order.
                        // This is not needed later!
                        .format(
                          DateTime(
                            snapshot.data!.keys.elementAt(yearIndex),
                            2,
                          ),
                        )
                        .toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .apply(fontFamily: "Questrial"),
                  ),
                ),
                content: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 18,
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
                            builder: (context) => const ImageView(),
                          ),
                        );
                      },
                      child: Image(
                        image: AssetImage("assets/images/${yearIndex + 1}.jpg"),
                        fit: BoxFit.cover,
                      ),
                    );
                  },
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
    );
  }
}
