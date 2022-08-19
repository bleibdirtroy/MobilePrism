import 'package:flutter/material.dart';
import 'package:mobileprism/constants/routes.dart';
import 'package:mobileprism/services/auth/auth_service.dart';
import 'package:mobileprism/views/home_view.dart';
import 'package:mobileprism/views/login_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService _authService = AuthService.secureStorage();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Prism',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        backgroundColor: Colors.black,
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
      home: FutureBuilder(
        future: _authService.isUserdataStored(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data! ? const HomeView() : const LoginView();
          } else {
            return Container(
              color: Theme.of(context).backgroundColor,
            );
          }
        },
      ),
    );
  }
}
