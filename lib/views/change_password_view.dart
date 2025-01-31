import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kasir_pintar/config.dart';
import 'package:kasir_pintar/components/input.dart';
import 'package:kasir_pintar/components/button.dart';
import 'package:kasir_pintar/components/snackbar.dart';

class ChangePasswordView extends StatefulWidget {
  @override
  _ChangePasswordViewState createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? token;
  String? email;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      token = args['token'];
      email = args['email'];
    }
  }

  Future<void> _changePassword() async {
    if (token == null || email == null) {
      showCustomSnackBar(context, 'Data tidak lengkap untuk mengubah password',
          SnackBarType.error);
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('${Config.apiUrl}/change-password'),
        body: {
          'email': email,
          'token': token,
          'old_password': _oldPasswordController.text,
          'new_password': _newPasswordController.text,
          'new_password_confirmation': _confirmPasswordController.text,
        },
      );

      if (response.statusCode == 200) {
        showCustomSnackBar(
            context, 'Password berhasil diubah', SnackBarType.success);
        Navigator.of(context).pushReplacementNamed('/login');
      } else {
        final errorResponse = jsonDecode(response.body);
        String errorMessage = '';

        if (errorResponse['errors'] is Map) {
          errorResponse['errors'].forEach((key, value) {
            errorMessage += '${value[0]}\n';
          });
        } else {
          errorMessage = 'Terjadi kesalahan. Silakan coba lagi.';
        }

        showCustomSnackBar(context, errorMessage.trim(), SnackBarType.error);
      }
    } catch (e) {
      showCustomSnackBar(
          context, 'Terjadi kesalahan. Silakan coba lagi.', SnackBarType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ubah Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Masukkan Password Baru',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            PasswordInput(
              label: 'Password Lama',
              controller: _oldPasswordController,
              isRequired: true,
            ),
            PasswordInput(
              label: 'Password Baru',
              controller: _newPasswordController,
              isRequired: true,
            ),
            PasswordInput(
              label: 'Konfirmasi Password Baru',
              controller: _confirmPasswordController,
              isRequired: true,
            ),
            SizedBox(height: 24),
            Button(
              text: 'Ubah Password',
              styleType: ButtonStyleType.green,
              onPressed: _changePassword,
            ),
          ],
        ),
      ),
    );
  }
}
