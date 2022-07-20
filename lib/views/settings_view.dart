import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobileprism/constants/application.dart';
import 'package:mobileprism/constants/routes.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Settings"),
          ListTile(
            leading: const Icon(Icons.key),
            title: const Text("Back to Login"),
            onTap: () => Navigator.of(context).pushReplacementNamed(loginRoute),
          ),
          const Divider(color: Colors.white),
          const Text("About us"),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.github),
            title: const Text("Github"),
            onTap: () => launchUrl(
              Uri.parse("https://github.com/bleibdirtroy/MobilePrism"),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.article),
            title: const Text("Licenses"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LicensePage(
                  applicationName: applicationName,
                  applicationVersion: applicationVersion,
                ),
              ),
            ),
          ),
          const Divider(color: Colors.white),
          const Text("About PhotoPrsim"),
          ListTile(
            leading: const Icon(Icons.public),
            title: const Text("Website"),
            onTap: () => launchUrl(
              Uri.parse("https://photoprism.app/"),
            ),
          ),
        ],
      ),
    );
  }
}
