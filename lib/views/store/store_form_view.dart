import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:kasir_pintar/config.dart';
import 'package:kasir_pintar/components/input.dart';
import 'package:kasir_pintar/components/file_input.dart';
import 'package:kasir_pintar/components/button.dart';
import 'package:kasir_pintar/components/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreFormView extends StatefulWidget {
  final Map<String, dynamic>? store;

  const StoreFormView({Key? key, this.store}) : super(key: key);

  @override
  _StoreFormViewState createState() => _StoreFormViewState();
}

class _StoreFormViewState extends State<StoreFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _postalCodeController = TextEditingController();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    print(widget.store);
    if (widget.store != null) {
      _nameController.text = widget.store!['name'] ?? '';
      _phoneController.text = widget.store!['number_phone'] ?? '';
      _addressController.text = widget.store!['address'] ?? '';
      _postalCodeController.text = widget.store!['postal_code'] ?? '';
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      // Handle store data update (JSON)
      if (widget.store != null) {
        // Update data toko
        final response = await http.patch(
          Uri.parse('${Config.apiUrl}/stores/${widget.store!['id']}'),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'name': _nameController.text,
            'number_phone': _phoneController.text,
            'address': _addressController.text,
            'postal_code': _postalCodeController.text,
          }),
        );

        final responseData = json.decode(response.body);
        if (response.statusCode != 200) {
          throw Exception(responseData['message'] ?? 'Gagal memperbarui toko');
        }

        // Update foto toko jika ada
        if (_selectedImage != null) {
          var imageRequest = http.MultipartRequest(
            'POST',
            Uri.parse('${Config.apiUrl}/stores/${widget.store!['id']}/image'),
          );

          imageRequest.headers['Authorization'] = 'Bearer $token';
          imageRequest.headers['Accept'] = 'application/json';

          imageRequest.files.add(await http.MultipartFile.fromPath(
            'image',
            _selectedImage!.path,
          ));

          final streamedResponse = await imageRequest.send();
          final imageResponse =
              await http.Response.fromStream(streamedResponse);

          if (imageResponse.statusCode != 200) {
            final imageData = json.decode(imageResponse.body);
            throw Exception(
                imageData['message'] ?? 'Gagal mengupload foto toko');
          }
        }
      } else {
        // Create new store
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('${Config.apiUrl}/stores'),
        );

        request.headers['Authorization'] = 'Bearer $token';
        request.headers['Accept'] = 'application/json';

        request.fields.addAll({
          'name': _nameController.text,
          'number_phone': _phoneController.text,
          'address': _addressController.text,
          'postal_code': _postalCodeController.text,
        });

        if (_selectedImage != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'image',
            _selectedImage!.path,
          ));
        }

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode != 201) {
          final responseData = json.decode(response.body);
          throw Exception(responseData['message'] ?? 'Gagal menambahkan toko');
        }
      }

      showCustomSnackBar(
        context,
        widget.store != null
            ? 'Toko berhasil diperbarui'
            : 'Toko berhasil ditambahkan',
        SnackBarType.success,
      );
      Navigator.pop(context);
    } catch (e) {
      showCustomSnackBar(
        context,
        'Gagal menyimpan data toko: ${e.toString()}',
        SnackBarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.store != null ? 'Edit Toko' : 'Tambah Toko'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              FileInput(
                label: 'Foto Toko',
                hintText: 'Pilih foto toko',
                isRequired: widget.store == null,
                initialValue: widget.store?['image_url'],
                onFileSelected: (file) {
                  setState(() => _selectedImage = file);
                },
              ),
              LabeledInput(
                label: 'Nama Toko',
                controller: _nameController,
                isRequired: true,
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
              LabeledInput(
                label: 'Kode Pos',
                controller: _postalCodeController,
                isRequired: true,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 24),
              Button(
                text: widget.store != null ? 'Simpan Perubahan' : 'Tambah Toko',
                styleType: ButtonStyleType.green,
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
