import 'package:flutter/material.dart';
import 'package:kasir_pintar/views/change_password_view.dart';
import 'package:kasir_pintar/views/forgot_password_view.dart';
import 'package:kasir_pintar/views/splash_view.dart';
import 'package:kasir_pintar/views/login_view.dart';
import 'package:kasir_pintar/views/register_view.dart';
import 'package:kasir_pintar/views/dashboard_view.dart';
import 'package:kasir_pintar/views/store/store_management_view.dart';
import 'package:kasir_pintar/views/store/store_form_view.dart';
import 'package:kasir_pintar/views/staff/staff_management_view.dart';
import 'package:kasir_pintar/views/staff/staff_form_view.dart';
import 'package:kasir_pintar/views/customer/customer_management_view.dart';
import 'package:kasir_pintar/views/customer/customer_form_view.dart';
import 'package:kasir_pintar/views/supplier/supplier_management_view.dart';
import 'package:kasir_pintar/views/supplier/supplier_form_view.dart';
import 'package:kasir_pintar/views/product/product_management_view.dart';
import 'package:kasir_pintar/views/product/product_form_view.dart';
import 'package:kasir_pintar/views/pos/pos_view.dart';

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
        '/forgot_password': (context) => ForgotPasswordView(),
        '/change_password': (context) => ChangePasswordView(),
        '/dashboard': (context) => DashboardView(),
        '/store': (context) => StoreManagementView(),
        '/store/create': (context) => StoreFormView(),
        '/store/edit': (context) => StoreFormView(
              store: ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?,
            ),
        '/staff': (context) => StaffManagementView(),
        '/staff/create': (context) => StaffFormView(),
        '/staff/edit': (context) => StaffFormView(
              staff: ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?,
            ),
        '/customer': (context) => CustomerManagementView(),
        '/customer/create': (context) => CustomerFormView(),
        '/customer/edit': (context) => CustomerFormView(
              customer: ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?,
            ),
        '/supplier': (context) => SupplierManagementView(),
        '/supplier/create': (context) => SupplierFormView(),
        '/supplier/edit': (context) => SupplierFormView(
              supplier: ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?,
            ),
        '/product': (context) => ProductManagementView(),
        '/product/create': (context) => ProductFormView(),
        '/product/edit': (context) => ProductFormView(
              product: ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?,
            ),
        '/pos': (context) => POSView(),
      },
    );
  }
}
