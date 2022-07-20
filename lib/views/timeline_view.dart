import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobileprism/constants/spacing.dart';
import 'package:mobileprism/views/image_view.dart';
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
      itemCount: 7,
      itemBuilder: (context, monthIndex) {
        return StickyHeader(
          header: Container(
            height: 50.0,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.centerLeft,
            child: Text(
              DateFormat('MMMM')
                  // 12 - is just used to display the months in reverese order.
                  // This is not needed later!
                  .format(DateTime(0, 12 - monthIndex))
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
                  image: AssetImage("assets/images/${monthIndex + 1}.jpg"),
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
