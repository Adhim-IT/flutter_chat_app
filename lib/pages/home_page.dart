import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/alert_service.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:flutter_chat_app/services/navigation_service.dart';
import 'package:get_it/get_it.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final GetIt _getIt = GetIt.instance;
  late AuthServcie _authServcie;
  late NavigationService _navigationService;
  late AlertService _alertService;
  @override
  void initState() {
    super.initState();
    _authServcie = _getIt<AuthServcie>();
    _navigationService = _getIt.get<NavigationService>();
    _alertService = _getIt.get<AlertService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Messenges",
        ),
        actions: [
          IconButton(
              onPressed: () async {
                bool result = await _authServcie.logout();
                if (result) {
                  _alertService.showToast(
                    text: "Logout Successfull",
                    icon: Icons.check,
                  );
                  _navigationService.pushReplacementNamed("/login");
                }
              },
              color: Colors.red,
              icon: const Icon(
                Icons.logout,
              ))
        ],
      ),
    );
  }
}
