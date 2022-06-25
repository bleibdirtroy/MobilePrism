import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              centerTitle: true,
              title: const Text("MobilePrism"),
              floating: true,
              forceElevated: innerBoxIsScrolled,
            ),
          ];
        },
        body: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView.builder(
            itemBuilder: ((context, index) {
              return StickyHeader(
                header: Container(
                  //height: 50.0,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Juni',
                    style: Theme.of(context).textTheme.headline4,
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
                  itemBuilder: (contxt, indx) {
                    return Image(
                      image:
                          AssetImage("images/${Random().nextInt(7) + 1}.jpg"),
                      fit: BoxFit.cover,
                    );
                  },
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
