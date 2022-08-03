import 'package:flutter/material.dart';
import 'package:mobileprism/constants/routes.dart';
import 'package:mobileprism/views/home_view.dart';
import 'package:mobileprism/views/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Prism',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0x00000000),
        textTheme: const TextTheme(
          bodySmall: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
          headlineSmall: TextStyle(color: Colors.white),
          headlineMedium: TextStyle(color: Colors.white),
          headlineLarge: TextStyle(color: Colors.white),
        ),
        cardColor: Colors.black,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
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
