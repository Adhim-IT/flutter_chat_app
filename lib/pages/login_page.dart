import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/consts.dart';
import 'package:flutter_chat_app/services/alert_service.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:flutter_chat_app/services/navigation_service.dart';
import 'package:flutter_chat_app/widgets/custom_form_field.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GetIt _getIt = GetIt.instance;
  final GlobalKey<FormState> _loginFormKey = GlobalKey();

  late AuthServcie _authService;
  late NavigationService _navigationService;
  late AlertService _alertService;

  String? email, password;
  bool showPassword = false;

  @override
  void initState() {
    super.initState();
    _authService = _getIt<AuthServcie>();
    _navigationService = _getIt.get<NavigationService>();
    _alertService = _getIt.get<AlertService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: Column(
          children: [
            _headerText(),
            _loginForm(),
            _createAnAccountLink(),
          ],
        ),
      ),
    );
  }

  Widget _headerText() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: const Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hai, Welcome Back!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: Colors.black87,
            ),
          ),
          Text(
            "Hello again, you've been missed!",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
              fontFamily: 'Poppins',
            ),
          )
        ],
      ),
    );
  }

  Widget _loginForm() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      height: MediaQuery.of(context).size.height * 0.50,
      child: Form(
        key: _loginFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomFormField(
              height: MediaQuery.of(context).size.height * 0.1,
              hintText: "Email",
              validationRegEx: EMAIL_VALIDATION_REGEX,
              onSaved: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            CustomFormField(
              height: MediaQuery.of(context).size.height * 0.1,
              hintText: "Password",
              validationRegEx: PASSWORD_VALIDATION_REGEX,
              obscureText: !showPassword,
              onSaved: (value) {
                setState(() {
                  password = value;
                });
              },
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
                icon: Icon(
                  showPassword ? Icons.visibility : Icons.visibility_off,
                ),
              ),
            ),
            _loginButton()
          ],
        ),
      ),
    );
  }

  Widget _loginButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        width: double.infinity,
        child: MaterialButton(
          onPressed: () async {
            if (_loginFormKey.currentState?.validate() ?? false) {
              _loginFormKey.currentState?.save();
              bool result = await _authService.login(email!, password!);
              if (result) {
                _navigationService.pushReplacementNamed("/home");
              } else {
                _alertService.showToast(
                  text: "Failed to login, try again",
                  icon: Icons.error,
                );
              }
            }
          },
          color: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: const Text(
            "Login",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _createAnAccountLink() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Text("Don't have an account?",
              style: TextStyle(fontFamily: 'Poppins')),
          GestureDetector(
            onTap: () {
              _navigationService.pushNamed("/register");
            },
            child: const Text(
              " Sign Up",
              style: TextStyle(
                  fontWeight: FontWeight.w800, fontFamily: 'Poppins'),
            ),
          )
        ],
      ),
    );
  }
}
