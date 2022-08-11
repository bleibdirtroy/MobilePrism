import 'package:flutter/material.dart';
import 'package:mobileprism/constants/routes.dart';
import 'package:mobileprism/services/auth/auth_service.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final AuthService _authService = AuthService.secureStorage();
  late final TextEditingController _hostnameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  bool isHostnameEmpty = false;

  @override
  void initState() {
    _hostnameController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _hostnameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _checkHostname() {
    _hostnameController.text.isEmpty
        ? isHostnameEmpty = true
        : isHostnameEmpty = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.black,
        child: Center(
          child: Container(
            constraints: BoxConstraints.loose(
              const Size(600, 600),
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  width: 200,
                  fit: BoxFit.fitWidth,
                ),
                Text(
                  'MobilePrism',
                  style: Theme.of(context).textTheme.headline4,
                ),
                TextField(
                  textInputAction: TextInputAction.next,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    labelText: 'Photoprism URL',
                    errorText: isHostnameEmpty ? "URL is missing" : null,
                  ),
                  controller: _hostnameController,
                ),
                TextField(
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                  ),
                  textInputAction: TextInputAction.next,
                  controller: _usernameController,
                ),
                TextField(
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  controller: _passwordController,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        key: const Key("loginbutton"),
                        onPressed: () async {
                          _checkHostname();
                          if (isHostnameEmpty) {
                            setState(() {});
                            return;
                          }
                          await _authService.storeUserData(
                            _hostnameController.text,
                            _usernameController.text,
                            _passwordController.text,
                          );
                          if (!mounted) return;
                          Navigator.pushReplacementNamed(
                            context,
                            homeRoute,
                          );
                        },
                        child: const Text('Login'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("MobilePrism"),
                                content: const Text(
                                  "Connect to your PhotoPrism® server using your PhotoPrism® url, username and password. Or connect to the public PhotoPrism® demo to test our app.",
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () async {
                                      await _authService
                                          .defaultPhotoprismServer();
                                      if (!mounted) return;
                                      Navigator.pushReplacementNamed(
                                        context,
                                        homeRoute,
                                      );
                                    },
                                    child: const Text('use demo server'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Icon(
                          Icons.help,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
