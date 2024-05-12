import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/consts.dart';
import 'package:flutter_chat_app/models/user_profile.dart';
import 'package:flutter_chat_app/services/alert_service.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:flutter_chat_app/services/database_service.dart';
import 'package:flutter_chat_app/services/media_service.dart';
import 'package:flutter_chat_app/services/navigation_service.dart';
import 'package:flutter_chat_app/services/storage_service.dart';
import 'package:flutter_chat_app/widgets/custom_form_field.dart';
import 'package:get_it/get_it.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GetIt _getIt = GetIt.instance;
  final GlobalKey<FormState> _registerFormKey = GlobalKey();
  late AuthServcie _authServcie;
  late MediaService _mediaService;
  late NavigationService _navigationService;
  late StorageService _storageService;
  late DatabaseService _databaseService;
  late AlertService _alertService;
  String? email, password, name;
  File? selectedImage;
  bool isLoading = false;
  bool showPassword = false;

  @override
  void initState() {
    super.initState();
    _mediaService = _getIt.get<MediaService>();
    _navigationService = _getIt.get<NavigationService>();
    _authServcie = _getIt.get<AuthServcie>();
    _storageService = _getIt.get<StorageService>();
    _databaseService = _getIt.get<DatabaseService>();
    _alertService = _getIt.get<AlertService>();
  }

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
            if (!isLoading) _registerForm(),
            _loginAnAccountLink(),
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
            "Let's get started!",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              fontFamily: "Poppies",
            ),
          ),
          Text(
            "Create an account",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              fontFamily: "Poppies",
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }

  Widget _registerForm() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      height: MediaQuery.of(context).size.height * 0.65,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.05,
      ),
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            _pfpSelectionField(),
            CustomFormField(
              hintText: "Email",
              height: MediaQuery.of(context).size.height * 0.1,
              validationRegEx: EMAIL_VALIDATION_REGEX,
              onSaved: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            CustomFormField(
              hintText: "Name",
              height: MediaQuery.of(context).size.height * 0.1,
              validationRegEx: NAME_VALIDATION_REGEX,
              onSaved: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            CustomFormField(
              hintText: "Password",
              height: MediaQuery.of(context).size.height * 0.1,
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
                    showPassword ? Icons.visibility : Icons.visibility_off),
              ),
            ),
            _registerButton(),
          ],
        ),
      ),
    );
  }

  Widget _pfpSelectionField() {
    return GestureDetector(
      onTap: () async {
        File? file = await _mediaService.getImageFromGallery();
        if (file != null) {
          setState(() {
            selectedImage = file;
          });
        }
      },
      child: CircleAvatar(
        radius: MediaQuery.of(context).size.width * 0.2,
        backgroundImage: selectedImage != null
            ? FileImage(selectedImage!)
            : NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
      ),
    );
  }

  Widget _registerButton() {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    child: MaterialButton(
      color: Theme.of(context).colorScheme.primary,
      onPressed: () async {
        setState(() {
          isLoading = true;
        });
        try {
          if ((_registerFormKey.currentState?.validate() ?? false) &&
              selectedImage != null) {
            _registerFormKey.currentState?.save();
            bool result = await _authServcie.signup(email!, password!);
            if (result) {
              String? pfpURL = await _storageService.uploadUserPfp(
                file: selectedImage!,
                uid: _authServcie.user!.uid,
              );
              if (pfpURL != null) {
                await _databaseService.createUserProfile(
                  userProfile: UserProfile(
                      uid: _authServcie.user!.uid,
                      name: name,
                      pfpURL: pfpURL),
                );
                _alertService.showToast(
                    text: "User registered successfully", icon: Icons.check);
                _navigationService.goBack();
                _navigationService.pushReplacementNamed("/home");
              } else {
                throw Exception("Unable to upload profile picture");
              }
            } else {
              throw Exception("Unable to register user");
            }
          }
        } catch (e) {
          print(e);
          _alertService.showToast(
            text: "Failed to register, try again",
            icon: Icons.error,
          );
        }
        setState(() {
          isLoading = false;
        });
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Set borderRadius
      ),
      child: const Text(
        "Register",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
  );
}


  Widget _loginAnAccountLink() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Text("Already have an account?"),
          GestureDetector(
            onTap: () {
              _navigationService.goBack();
            },
            child: const Text(
              " Sign In",
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}
