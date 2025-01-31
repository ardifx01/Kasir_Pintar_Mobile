import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kasir_pintar/config.dart';
import 'package:kasir_pintar/components/input.dart';
import 'package:kasir_pintar/components/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kasir_pintar/components/button.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final response = await http.post(
      Uri.parse('${Config.apiUrl}/login'),
      body: {
        'email': _emailController.text,
        'password': _passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final accessToken = responseData['access_token'];
      final user = responseData['user'];
      final userId = user['id'];
      final userRole = user['role'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', accessToken);
      await prefs.setInt('user_id', userId);
      await prefs.setString('user_role', userRole);
      Navigator.of(context).pushNamed('/dashboard');
    } else {
      final errorResponse = jsonDecode(response.body);
      final errors = errorResponse['errors'];
      String errorMessage = '';
      if (errors.containsKey('email')) {
        errorMessage += errors['email'][0];
      }
      if (errors.containsKey('password')) {
        errorMessage += errors['password'][0];
      }
      showCustomSnackBar(context, errorMessage, SnackBarType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text('Masuk'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Selamat datang kembali',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Silakan masukkan email dan password Anda',
              style: TextStyle(fontSize: 16),
            ),
            LabeledInput(
              label: 'Email',
              controller: _emailController,
            ),
            PasswordInput(
              label: 'Password',
              controller: _passwordController,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/forgot_password');
                },
                child: Text('Lupa Password?'),
              ),
            ),
            Button(
              text: 'Login',
              styleType: ButtonStyleType.green,
              onPressed: () {
                _login();
              },
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Belum punya akun?'),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/register');
                    },
                    child: Text('Daftar di sini'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
