import 'package:flutter/material.dart';
import 'package:mobileprism/constants/routes.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(loginRoute);
              },
              child: const Text("Back to Login"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LicensePage(),
                  ),
                );
              },
              child: const Text("Licenses"),
            ),
          ],
        ),
      ),
    );
  }
}
