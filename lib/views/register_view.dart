import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kasir_pintar/config.dart';
import 'package:kasir_pintar/components/input.dart';
import 'package:kasir_pintar/components/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kasir_pintar/components/button.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();

  Future<void> _register() async {
    final response = await http.post(
      Uri.parse('${Config.apiUrl}/register'),
      body: {
        'name': _usernameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'password_confirmation': _passwordConfirmationController.text,
      },
    );

    if (response.statusCode == 201) {
      Navigator.of(context).pop();
    } else {
      final errorResponse = jsonDecode(response.body);
      final errors = errorResponse['errors'];
      String errorMessage = '';
      if (errors.containsKey('username')) {
        errorMessage += errors['username'][0];
      }
      if (errors.containsKey('email')) {
        errorMessage += errors['email'][0];
      }
      if (errors.containsKey('password')) {
        errorMessage += errors['password'][0];
      }
      if (errors.containsKey('password_confirmation')) {
        errorMessage += errors['password_confirmation'][0];
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
          child: Text('Daftar'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Selamat datang di aplikasi kami',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Silakan isi formulir pendaftaran di bawah ini',
              style: TextStyle(fontSize: 16),
            ),
            LabeledInput(
              label: 'Username',
              controller: _usernameController,
            ),
            LabeledInput(
              label: 'Email',
              controller: _emailController,
            ),
            PasswordInput(
              label: 'Password',
              controller: _passwordController,
            ),
            PasswordInput(
              label: 'Konfirmasi Password',
              controller: _passwordConfirmationController,
            ),
            Button(
              text: 'Daftar',
              styleType: ButtonStyleType.green,
              onPressed: () {
                _register();
              },
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Sudah punya akun?'),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/login');
                    },
                    child: Text('Masuk di sini'),
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
