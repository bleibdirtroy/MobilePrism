import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MobilePrism"),
      ),
      body: Container(
        child: GridView.count(
          crossAxisCount: 5,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: [
            for (int i = 0; i < 98; i++)
              Image(
                image: AssetImage("images/${i % 8 + 1}.jpg"),
                fit: BoxFit.cover,
              ),
          ],
        ),
      ),
    );
  }
}
