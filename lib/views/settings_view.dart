import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobileprism/constants/application.dart';
import 'package:mobileprism/constants/routes.dart';
import 'package:mobileprism/models/photo_prism_server.dart';
import 'package:mobileprism/services/auth/auth_service.dart';
import 'package:mobileprism/services/controller/data_controller.dart';
import 'package:mobileprism/services/settings/settings_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final AuthService _authService = AuthService.secureStorage();
  final DataController _dataController = DataController();
  int progressCurrent = 0;
  int progressMax = 0;

  Future<void> preloadTimeline() async {
    progressMax = 0;
    progressCurrent = 0;
    PhotoPrismServer().useDatabaseOnly = false;
    setState(() {});
    final dates = await _dataController.getOccupiedDates();
    dates.forEach((year, months) => progressMax += months.length);
    setState(() {});
    final futures = <Future>[];
    dates.forEach((year, months) async {
      for (final month in months) {
        futures.add(
          _dataController.getPhotosOfMonthAndYear(
            DateTime(
              year,
              month,
            ),
          ),
        );
      }
    });
    for (final element in futures) {
      element.then((value) {
        if (mounted) {
          setState(() {
            progressCurrent++;
          });
        }
      });
    }
    Future.wait(futures).then((value) {
      PhotoPrismServer().useDatabaseOnly = true;
      SettingsService().setUseDatabase();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preload finished'),
        ),
      );
    });
  }

  @override
  void initState() {
    progressMax = 0;
    progressCurrent = 0;
    super.initState();
  }

  Future<void> _deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();

    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Your Server"),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text("Hostname"),
              subtitle: Text(PhotoPrismServer().hostname),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Username"),
              subtitle: Text(PhotoPrismServer().username),
            ),
            const Divider(color: Colors.white),
            const Text("App Settings"),
            ListTile(
              leading: const Icon(Icons.key),
              title: const Text("Back to Login"),
              onTap: () async {
                await _authService.deleteUserData();
                await DefaultCacheManager().emptyCache();
                await _deleteAppDir();
                Restart.restartApp(webOrigin: loginRoute);
                if (!mounted) return;
                Navigator.of(context).pushReplacementNamed(loginRoute);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text("Clear image cache"),
              onTap: () async {
                await DefaultCacheManager().emptyCache();
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cache cleared'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.browse_gallery),
              title: const Text("Preload Timeline"),
              trailing: Text("$progressCurrent/$progressMax"),
              onTap: () {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Preload started'),
                  ),
                );
                preloadTimeline();
              },
            ),
            ListTile(
              leading: const Icon(Icons.storage),
              title: const Text("Use database only"),
              trailing: Switch(
                value: PhotoPrismServer().useDatabaseOnly,
                onChanged: (value) {
                  PhotoPrismServer().useDatabaseOnly =
                      !PhotoPrismServer().useDatabaseOnly;
                  SettingsService().setUseDatabase();
                  setState(() {});
                },
              ),
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
      ),
    );
  }
}
