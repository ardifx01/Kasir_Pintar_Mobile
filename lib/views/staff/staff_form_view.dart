import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kasir_pintar/components/dropdown.dart';
import 'dart:convert';
import 'package:kasir_pintar/config.dart';
import 'package:kasir_pintar/components/input.dart';
import 'package:kasir_pintar/components/button.dart';
import 'package:kasir_pintar/components/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StaffFormView extends StatefulWidget {
  final Map<String, dynamic>? staff;

  const StaffFormView({Key? key, this.staff}) : super(key: key);

  @override
  _StaffFormViewState createState() => _StaffFormViewState();
}

class _StaffFormViewState extends State<StaffFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _roleController = TextEditingController();
  int? _selectedStoreId;
  List<Map<String, dynamic>> stores = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.staff != null) {
      _nameController.text = widget.staff!['user']['name'] ?? '';
      _emailController.text = widget.staff!['user']['email'] ?? '';
      _phoneController.text = widget.staff!['user']['number_phone'] ?? '';
      _roleController.text = widget.staff!['role'] ?? '';
      _selectedStoreId = widget.staff!['store']['id'];
    }
    _fetchStores();
  }

  Future<void> _fetchStores() async {
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
        });
      } else {
        throw Exception('Gagal memuat data toko');
      }
    } catch (e) {
      showCustomSnackBar(context, 'Gagal memuat data toko', SnackBarType.error);
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final Map<String, dynamic> data = {
        'name': _nameController.text,
        'email': _emailController.text,
        'number_phone': _phoneController.text,
        'store_id': _selectedStoreId,
        'role': _roleController.text,
      };

      final response = widget.staff != null
          ? await _updateStaff(token!, data)
          : await _createStaff(token!, data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar(
          context,
          widget.staff != null
              ? 'Staff berhasil diperbarui'
              : 'Staff berhasil ditambahkan',
          SnackBarType.success,
        );
        Navigator.pop(context);
      } else {
        final responseData = json.decode(response.body);
        throw Exception(
            responseData['message'] ?? 'Gagal menyimpan data staff');
      }
    } catch (e) {
      showCustomSnackBar(
        context,
        'Gagal menyimpan data staff: ${e.toString()}',
        SnackBarType.error,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<http.Response> _createStaff(
      String token, Map<String, dynamic> data) async {
    data['password'] = _passwordController.text; // Password wajib saat create

    return await http.post(
      Uri.parse('${Config.apiUrl}/staffs'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );
  }

  Future<http.Response> _updateStaff(
      String token, Map<String, dynamic> data) async {
    if (_passwordController.text.isNotEmpty) {
      data['password'] =
          _passwordController.text; // Password opsional saat update
    }

    return await http.put(
      Uri.parse('${Config.apiUrl}/staffs/${widget.staff!['id']}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.staff != null ? 'Edit Staff' : 'Tambah Staff'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  LabeledInput(
                    label: 'Nama',
                    controller: _nameController,
                    isRequired: true,
                  ),
                  LabeledInput(
                    label: 'Email',
                    controller: _emailController,
                    isRequired: true,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  if (widget.staff == null)
                    LabeledInput(
                      label: 'Password',
                      controller: _passwordController,
                      isRequired: true,
                    ),
                  LabeledInput(
                    label: 'Nomor Telepon',
                    controller: _phoneController,
                    isRequired: true,
                    keyboardType: TextInputType.phone,
                  ),
                  // Dropdown Store
                  CustomDropdown(
                    label: 'Toko',
                    hint: 'Pilih Toko',
                    value: _selectedStoreId?.toString(),
                    items: stores.map((store) {
                      return {
                        'value': store['id'].toString(),
                        'label': store['name'].toString(),
                      };
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedStoreId = int.parse(value!));
                    },
                    isRequired: true,
                    errorText: _selectedStoreId == null ? 'Pilih toko' : null,
                  ),
                  SizedBox(height: 16),

                  // Input Role
                  LabeledInput(
                    label: 'Role',
                    controller: _roleController,
                    isRequired: true,
                  ),
                  SizedBox(height: 24),
                  Button(
                    text: widget.staff != null
                        ? 'Simpan Perubahan'
                        : 'Tambah Staff',
                    styleType: ButtonStyleType.green,
                    onPressed: isLoading
                        ? null
                        : () {
                            _submitForm();
                          },
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black26,
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
