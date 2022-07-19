import 'package:flutter/material.dart';
import 'package:mobileprism/constants/routes.dart';
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
        scaffoldBackgroundColor: const Color(0x00000000),
        textTheme: const TextTheme(
          bodySmall: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
          headlineSmall: TextStyle(color: Colors.white),
          headlineMedium: TextStyle(color: Colors.white),
          headlineLarge: TextStyle(color: Colors.white),
        ),
        listTileTheme: const ListTileThemeData(
          iconColor: Colors.white,
          textColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
        ),
      ),
      routes: {
        loginRoute: (context) => const LoginView(),
        homeRoute: (context) => const HomeView(),
      },
      home: const LoginView(),
    );
  }
}
