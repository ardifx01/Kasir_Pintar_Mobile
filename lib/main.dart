import 'package:flutter/material.dart';
import 'package:kasir_pintar/views/splash_view.dart';
import 'package:kasir_pintar/views/login_view.dart';
import 'package:kasir_pintar/views/register_view.dart';
import 'package:kasir_pintar/views/dashboard_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kasir Pintar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashView(),
        '/login': (context) => LoginView(),
        '/register': (context) => RegisterView(),
        '/dashboard': (context) => DashboardView(),
      },
    );
  }
}
