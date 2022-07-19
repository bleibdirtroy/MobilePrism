import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class TimelineView extends StatefulWidget {
  const TimelineView({Key? key}) : super(key: key);

  @override
  State<TimelineView> createState() => _TimelineViewState();
}

class _TimelineViewState extends State<TimelineView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, monthIndex) {
        return StickyHeader(
          header: Container(
            height: 50.0,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.centerLeft,
            child: Text(
              DateFormat.MMMM()
                  .format(
                    DateTime.now(),
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
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemBuilder: (contxt, imageIndex) {
              return InkWell(
                onTap: () {
                  log("image $monthIndex / $imageIndex Tab");
                },
                child: const Image(
                  image: AssetImage("assets/images/1.jpg"),
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
