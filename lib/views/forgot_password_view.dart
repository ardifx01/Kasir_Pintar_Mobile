import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kasir_pintar/config.dart';
import 'package:kasir_pintar/components/input.dart';
import 'package:kasir_pintar/components/button.dart';
import 'package:kasir_pintar/components/snackbar.dart';

class ForgotPasswordView extends StatefulWidget {
  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController _emailController = TextEditingController();

  Future<void> _forgotPassword() async {
    try {
      final response = await http.post(
        Uri.parse('${Config.apiUrl}/forgot-password'),
        body: {
          'email': _emailController.text,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['token'];

        showCustomSnackBar(
            context,
            'Link reset password telah dikirim ke email Anda',
            SnackBarType.success);

        Navigator.pushNamed(context, '/change_password',
            arguments: {'token': token, 'email': _emailController.text});
      } else {
        final errorResponse = jsonDecode(response.body);
        String errorMessage = '';

        if (errorResponse['errors'] is Map) {
          if (errorResponse['errors']['email'] != null) {
            errorMessage = errorResponse['errors']['email'][0];
          }
        } else {
          errorMessage = 'Terjadi kesalahan. Silakan coba lagi.';
        }

        showCustomSnackBar(context, errorMessage, SnackBarType.error);
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
        title: Text('Lupa Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Masukkan email Anda',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Kami akan mengirimkan link reset password ke email Anda',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            LabeledInput(
              label: 'Email',
              controller: _emailController,
              isRequired: true,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 24),
            Button(
              text: 'Kirim Link',
              styleType: ButtonStyleType.green,
              onPressed: _forgotPassword,
            ),
          ],
        ),
      ),
    );
  }
}
