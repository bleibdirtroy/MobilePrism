import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobileprism/constants/spacing.dart';

class AlbumsView extends StatelessWidget {
  const AlbumsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        itemCount: 27,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              log("album $index touched");
            },
            child: GridTile(
              footer: GridTileBar(
                backgroundColor: Colors.black54,
                title: Text("Album Nr. $index"),
              ),
              child: Image.asset(
                "assets/images/${(index % 8) + 1}.jpg",
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
