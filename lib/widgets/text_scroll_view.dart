import 'package:flutter/material.dart';

class TextScrollView extends StatelessWidget {
  final String text;
  const TextScrollView({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height -
            kBottomNavigationBarHeight -
            kBottomNavigationBarHeight,
        child: Center(
          child: Text(text),
        ),
      ),
    );
  }
}
