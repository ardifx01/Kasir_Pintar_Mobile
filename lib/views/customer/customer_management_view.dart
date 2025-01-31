import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kasir_pintar/config.dart';
import 'package:kasir_pintar/components/card.dart';
import 'package:kasir_pintar/components/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerManagementView extends StatefulWidget {
  @override
  _CustomerManagementViewState createState() => _CustomerManagementViewState();
}

class _CustomerManagementViewState extends State<CustomerManagementView> {
  List<Map<String, dynamic>> customers = [];
  bool isLoading = true;
  String? userRole;
  int? storeId;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('user_role');
      storeId = prefs.getInt('store_id');
    });
    fetchCustomers();
  }

  Future<void> fetchCustomers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final url = storeId != null
          ? '${Config.apiUrl}/customers/store/$storeId'
          : '${Config.apiUrl}/customers';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          customers = List<Map<String, dynamic>>.from(data);
          isLoading = false;
        });
      } else {
        throw Exception('Gagal memuat data customer');
      }
    } catch (e) {
      setState(() => isLoading = false);
      showCustomSnackBar(context, e.toString(), SnackBarType.error);
    }
  }

  Future<void> _handleDeleteCustomer(Map<String, dynamic> customer) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final response = await http.delete(
        Uri.parse('${Config.apiUrl}/customers/${customer['id']}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        showCustomSnackBar(
          context,
          'Customer berhasil dihapus',
          SnackBarType.success,
        );
        fetchCustomers();
      } else {
        throw Exception('Gagal menghapus customer');
      }
    } catch (e) {
      showCustomSnackBar(context, e.toString(), SnackBarType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manajemen Customer'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/customer/create')
            .then((_) => fetchCustomers()),
        child: Icon(Icons.add),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
                return ContactCard(
                  storeId: customer['store_id'],
                  name: customer['name'],
                  numberPhone: customer['number_phone'],
                  address: customer['address'],
                  email: customer['email'] ?? '',
                  type: ContactType.customer,
                  onEdit: () {
                    Navigator.pushNamed(
                      context,
                      '/customer/edit',
                      arguments: customer,
                    ).then((_) => fetchCustomers());
                  },
                  onDelete: () => _handleDeleteCustomer(customer),
                );
              },
            ),
    );
  }
}
