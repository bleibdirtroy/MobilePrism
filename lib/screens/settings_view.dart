import 'package:flutter/material.dart';
import 'package:mobileprism/constants/routes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(loginRoute);
            },
            child: const Text("Back to Login"),
          ),
          const Divider(color: Colors.white),
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
          const Divider(color: Colors.white),
          const Text("About us"),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.github),
            title: const Text("Github"),
            onTap: () => launchUrl(
              Uri.parse("https://github.com/bleibdirtroy/MobilePrism"),
            ),
          )
        ],
      ),
    );
  }
}
