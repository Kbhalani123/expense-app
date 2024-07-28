import 'package:app_me/12/screen/homescreen.dart';
import 'package:app_me/12/screen/login_screen.dart';
import 'package:app_me/12/shareprefence/pref_management.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _checkUserSession(context);
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _checkUserSession(BuildContext context) async {
    SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
    final userId = await prefsHelper.getUserId();
    await Future.delayed(Duration(seconds: 2)); // Simulate a loading time
    if (userId != null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }
}