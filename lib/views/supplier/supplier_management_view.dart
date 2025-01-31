import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kasir_pintar/config.dart';
import 'package:kasir_pintar/components/card.dart';
import 'package:kasir_pintar/components/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupplierManagementView extends StatefulWidget {
  @override
  _SupplierManagementViewState createState() => _SupplierManagementViewState();
}

class _SupplierManagementViewState extends State<SupplierManagementView> {
  List<Map<String, dynamic>> suppliers = [];
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
    fetchSuppliers();
  }

  Future<void> fetchSuppliers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final url = storeId != null
          ? '${Config.apiUrl}/suppliers/store/$storeId'
          : '${Config.apiUrl}/suppliers';

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
          suppliers = List<Map<String, dynamic>>.from(data);
          isLoading = false;
        });
      } else {
        throw Exception('Gagal memuat data supplier');
      }
    } catch (e) {
      setState(() => isLoading = false);
      showCustomSnackBar(context, e.toString(), SnackBarType.error);
    }
  }

  Future<void> _handleDeleteSupplier(Map<String, dynamic> supplier) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final response = await http.delete(
        Uri.parse('${Config.apiUrl}/suppliers/${supplier['id']}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        showCustomSnackBar(
          context,
          'Supplier berhasil dihapus',
          SnackBarType.success,
        );
        fetchSuppliers();
      } else {
        throw Exception('Gagal menghapus supplier');
      }
    } catch (e) {
      showCustomSnackBar(context, e.toString(), SnackBarType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userRole != 'admin' && userRole != 'owner') {
      return Scaffold(
        appBar: AppBar(title: Text('Manajemen Supplier')),
        body: Center(
          child: Text('Anda tidak memiliki akses ke halaman ini'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Manajemen Supplier'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/supplier/create')
            .then((_) => fetchSuppliers()),
        child: Icon(Icons.add),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: suppliers.length,
              itemBuilder: (context, index) {
                final supplier = suppliers[index];
                return ContactCard(
                  storeId: supplier['store_id'],
                  name: supplier['name'],
                  numberPhone: supplier['number_phone'],
                  address: supplier['address'],
                  email: supplier['email'] ?? '',
                  type: ContactType.supplier,
                  onEdit: () {
                    Navigator.pushNamed(
                      context,
                      '/supplier/edit',
                      arguments: supplier,
                    ).then((_) => fetchSuppliers());
                  },
                  onDelete: () => _handleDeleteSupplier(supplier),
                );
              },
            ),
    );
  }
}
