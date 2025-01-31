import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kasir_pintar/config.dart';
import 'package:kasir_pintar/components/card.dart';
import 'package:kasir_pintar/components/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreManagementView extends StatefulWidget {
  @override
  _StoreManagementViewState createState() => _StoreManagementViewState();
}

class _StoreManagementViewState extends State<StoreManagementView> {
  List<Map<String, dynamic>> stores = [];
  bool isLoading = true;
  String? userRole;

  @override
  void initState() {
    super.initState();
    _getUserRole();
    fetchStores();
  }

  Future<void> _getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('user_role');
    });
  }

  Future<void> fetchStores() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final response = await http.get(
        Uri.parse('${Config.apiUrl}/stores'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          stores = List<Map<String, dynamic>>.from(data);
          isLoading = false;
        });
      } else if (response.statusCode == 403) {
        throw Exception('Anda tidak memiliki akses');
      } else {
        throw Exception('Gagal memuat data toko');
      }
    } catch (e) {
      setState(() => isLoading = false);
      showCustomSnackBar(context, e.toString(), SnackBarType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Hanya tampilkan jika user adalah admin atau owner
    if (userRole != 'admin' && userRole != 'owner') {
      return Scaffold(
        appBar: AppBar(
          title: Text('Manajemen Toko'),
        ),
        body: Center(
          child: Text('Anda tidak memiliki akses ke halaman ini'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Manajemen Toko'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/store/create')
            .then((_) => fetchStores()),
        child: Icon(Icons.add),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : StoreGrid(
              stores: stores,
              onStoreSelected: (store) {
                Navigator.pushNamed(
                  context,
                  '/store/edit',
                  arguments: store,
                ).then((_) => fetchStores());
              },
              onEditStore: (store) {
                Navigator.pushNamed(
                  context,
                  '/store/edit',
                  arguments: store,
                ).then((_) => fetchStores());
              },
              onDeleteStore: _handleDeleteStore,
            ),
    );
  }

  Future<void> _handleDeleteStore(Map<String, dynamic> store) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Toko'),
        content: Text('Yakin ingin menghapus toko ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Hapus'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('access_token');

        final response = await http.delete(
          Uri.parse('${Config.apiUrl}/stores/${store['id']}'),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          showCustomSnackBar(
            context,
            'Toko berhasil dihapus',
            SnackBarType.success,
          );
          fetchStores();
        } else if (response.statusCode == 403) {
          throw Exception('Anda tidak memiliki akses untuk menghapus toko ini');
        } else {
          throw Exception('Gagal menghapus toko');
        }
      } catch (e) {
        showCustomSnackBar(context, e.toString(), SnackBarType.error);
      }
    }
  }
}
