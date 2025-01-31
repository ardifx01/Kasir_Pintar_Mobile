import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kasir_pintar/config.dart';
import 'package:kasir_pintar/components/card.dart';
import 'package:kasir_pintar/components/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StaffManagementView extends StatefulWidget {
  @override
  _StaffManagementViewState createState() => _StaffManagementViewState();
}

class _StaffManagementViewState extends State<StaffManagementView> {
  List<Map<String, dynamic>> staffList = [];
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
    fetchStaff();
  }

  Future<void> fetchStaff() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final url = storeId != null
          ? '${Config.apiUrl}/staffs/store/$storeId'
          : '${Config.apiUrl}/staffs';

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
          staffList = List<Map<String, dynamic>>.from(data);
          isLoading = false;
        });
      } else {
        throw Exception('Gagal memuat data staff');
      }
    } catch (e) {
      setState(() => isLoading = false);
      showCustomSnackBar(context, e.toString(), SnackBarType.error);
    }
  }

  Future<void> _handleDeleteStaff(Map<String, dynamic> staff) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final response = await http.delete(
        Uri.parse('${Config.apiUrl}/staffs/${staff['id']}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        showCustomSnackBar(
          context,
          'Staff berhasil dihapus',
          SnackBarType.success,
        );
        fetchStaff();
      } else {
        throw Exception('Gagal menghapus staff');
      }
    } catch (e) {
      showCustomSnackBar(context, e.toString(), SnackBarType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userRole != 'admin' && userRole != 'owner') {
      return Scaffold(
        appBar: AppBar(title: Text('Manajemen Staff')),
        body: Center(
          child: Text('Anda tidak memiliki akses ke halaman ini'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Manajemen Staff'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/staff/create')
            .then((_) => fetchStaff()),
        child: Icon(Icons.add),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : StaffList(
              staffList: staffList,
              onEditStaff: (staff) {
                Navigator.pushNamed(
                  context,
                  '/staff/edit',
                  arguments: staff,
                ).then((_) => fetchStaff());
              },
              onDeleteStaff: _handleDeleteStaff,
            ),
    );
  }
}
