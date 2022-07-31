import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobileprism/constants/application.dart';
import 'package:mobileprism/constants/routes.dart';
import 'package:mobileprism/services/auth/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final AuthService _authService = AuthService.secureStorage();
  String hostname = "";
  String username = "";

  Future<void> loadCredentials() async {
    hostname = await _authService.getHostname();
    username = await _authService.getUsername();
    setState(() {});
  }

  @override
  void initState() {
    loadCredentials();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Settings"),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text("Hostname"),
            subtitle: Text(hostname),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Username"),
            subtitle: Text(username),
          ),
          ListTile(
            leading: const Icon(Icons.key),
            title: const Text("Back to Login"),
            onTap: () async {
              await _authService.deleteUserData();
              if (!mounted) return;
              Navigator.of(context).pushReplacementNamed(loginRoute);
            },
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
