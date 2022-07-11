import 'package:flutter/material.dart';
import 'package:mobileprism/screens/home_view.dart';
import 'package:mobileprism/screens/login_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Prism',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      routes: {
        '/login/': (context) => const LoginView(),
        '/home/': (context) => const HomeView(),
      },
      home: const LoginView(),
    );
  }
}
