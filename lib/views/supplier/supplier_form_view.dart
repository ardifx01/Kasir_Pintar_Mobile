import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kasir_pintar/config.dart';
import 'package:kasir_pintar/components/input.dart';
import 'package:kasir_pintar/components/button.dart';
import 'package:kasir_pintar/components/snackbar.dart';
import 'package:kasir_pintar/components/dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupplierFormView extends StatefulWidget {
  final Map<String, dynamic>? supplier;
  const SupplierFormView({Key? key, this.supplier}) : super(key: key);

  @override
  _SupplierFormViewState createState() => _SupplierFormViewState();
}

class _SupplierFormViewState extends State<SupplierFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  int? _selectedStoreId;
  List<Map<String, dynamic>> stores = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.supplier != null) {
      _nameController.text = widget.supplier!['name'];
      _emailController.text = widget.supplier!['email'] ?? '';
      _phoneController.text = widget.supplier!['number_phone'];
      _addressController.text = widget.supplier!['address'];
      _selectedStoreId = widget.supplier!['store_id'];
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
        'address': _addressController.text,
        'store_id': _selectedStoreId,
      };

      final response = widget.supplier != null
          ? await _updateSupplier(token!, data)
          : await _createSupplier(token!, data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar(
          context,
          widget.supplier != null
              ? 'Supplier berhasil diperbarui'
              : 'Supplier berhasil ditambahkan',
          SnackBarType.success,
        );
        Navigator.pop(context);
      } else {
        throw Exception('Gagal menyimpan data supplier');
      }
    } catch (e) {
      showCustomSnackBar(
        context,
        'Gagal menyimpan data supplier: ${e.toString()}',
        SnackBarType.error,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<http.Response> _createSupplier(
      String token, Map<String, dynamic> data) async {
    return await http.post(
      Uri.parse('${Config.apiUrl}/suppliers'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );
  }

  Future<http.Response> _updateSupplier(
      String token, Map<String, dynamic> data) async {
    return await http.put(
      Uri.parse('${Config.apiUrl}/suppliers/${widget.supplier!['id']}'),
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
        title:
            Text(widget.supplier != null ? 'Edit Supplier' : 'Tambah Supplier'),
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
                    keyboardType: TextInputType.emailAddress,
                  ),
                  LabeledInput(
                    label: 'Nomor Telepon',
                    controller: _phoneController,
                    isRequired: true,
                    keyboardType: TextInputType.phone,
                  ),
                  LabeledInput(
                    label: 'Alamat',
                    controller: _addressController,
                    isRequired: true,
                    maxLines: 3,
                  ),
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
                  SizedBox(height: 24),
                  Button(
                    text: widget.supplier != null
                        ? 'Simpan Perubahan'
                        : 'Tambah Supplier',
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
