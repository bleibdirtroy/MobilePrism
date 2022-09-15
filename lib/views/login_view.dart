import 'package:flutter/material.dart';
import 'package:mobileprism/constants/routes.dart';
import 'package:mobileprism/services/auth/auth_service.dart';
import 'package:mobileprism/services/rest_api/rest_api_service.dart';
import 'package:mobileprism/widgets/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final AuthService _authService = AuthService.secureStorage();
  late final TextEditingController _hostnameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  bool isHostnameEmpty = false;
  bool _isLoginButtonDisabled = false;

  @override
  void initState() {
    _hostnameController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _hostnameController.text = "";
    _usernameController.text = "";
    _passwordController.text = "";
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

  VoidCallback? _login() {
    if (_isLoginButtonDisabled) {
      return null;
    } else {
      return () async {
        setState(() {
          _isLoginButtonDisabled = true;
        });

        _checkHostname();
        if (isHostnameEmpty) {
          setState(() {
            _isLoginButtonDisabled = false;
          });
          return;
        }
        String sessionToken = "";
        String previewToken = "";

        if (_hostnameController.text.isEmpty) {
          previewToken = "public";
        } else {
          try {
            final token = await RestApiService().login(
              _hostnameController.text,
              _usernameController.text,
              _passwordController.text,
            );
            sessionToken = token.first;
            previewToken = token.last;
          } catch (e) {
            setState(() {
              _isLoginButtonDisabled = false;
            });
            await showErrorDialog(
              context,
              "Cannot connect to your PhotoPrism Server.",
            );
            return;
          }
        }

        await _authService.storeUserData(
          hostname: _hostnameController.text,
          username: _usernameController.text,
          password: _passwordController.text,
          sessionToken: sessionToken,
          previewToken: previewToken,
        );
        if (!mounted) return;
        Navigator.of(context).pushNamedAndRemoveUntil(
          homeRoute,
          (route) => false,
        );
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ColoredBox(
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
                  Expanded(
                    child: Image.asset(
                      "assets/images/logo.png",
                      width: 200,
                    ),
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
                          onPressed: _login(),
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
                                    "Connect to your PhotoPrism server using your PhotoPrism url, username and password. Or connect to the public PhotoPrism demo to test our app.",
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () async {
                                        await _authService
                                            .demoPhotoprismServer();
                                        if (!mounted) return;
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                          homeRoute,
                                          (route) => false,
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
      ),
    );
  }
}
