import 'package:app_me/12/database/db_helper.dart';
import 'package:app_me/12/screen/signup_screen.dart';
import 'package:app_me/12/shareprefence/pref_management.dart';
import 'package:flutter/material.dart';
import 'homescreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  DatabaseHelper _databaseHelper = DatabaseHelper();
  SharedPreferencesHelper _sharedPreferencesHelper = SharedPreferencesHelper();

  Future<void> login() async {
    int userId = await _databaseHelper.getUser(emailController.text, passwordController.text);
    if (userId != -1) {
      await _sharedPreferencesHelper.saveUserId(userId);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid credentials')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: Text('Login')),
            TextButton(
              child: Text("Don't have an account? Sign Up"),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}