import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:kasir_pintar/config.dart';
import 'package:kasir_pintar/components/input.dart';
import 'package:kasir_pintar/components/button.dart';
import 'package:kasir_pintar/components/dropdown.dart';
import 'package:kasir_pintar/components/file_input.dart';
import 'package:kasir_pintar/components/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductFormView extends StatefulWidget {
  final Map<String, dynamic>? product;
  const ProductFormView({Key? key, this.product}) : super(key: key);

  @override
  _ProductFormViewState createState() => _ProductFormViewState();
}

class _ProductFormViewState extends State<ProductFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _stockController = TextEditingController();
  final _unitController = TextEditingController();

  int? _selectedStoreId;
  int? _selectedCategoryId;
  List<Map<String, dynamic>> stores = [];
  List<Map<String, dynamic>> categories = [];
  File? _imageFile;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!['name_product'];
      _codeController.text = widget.product!['code_product'];
      _sellingPriceController.text =
          widget.product!['selling_price'].toString();
      _purchasePriceController.text =
          widget.product!['purchase_price'].toString();
      _stockController.text = widget.product!['stock'].toString();
      _unitController.text = widget.product!['unit'];
      _selectedStoreId = widget.product!['store_id'];
      _selectedCategoryId = widget.product!['category_product_id'];
    }
    _fetchStores();
    _fetchCategories();
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

  Future<void> _fetchCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final response = await http.get(
        Uri.parse('${Config.apiUrl}/categories'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          categories = List<Map<String, dynamic>>.from(data);
        });
      } else {
        throw Exception('Gagal memuat kategori');
      }
    } catch (e) {
      showCustomSnackBar(context, 'Gagal memuat kategori: ${e.toString()}',
          SnackBarType.error);
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      // Data produk dalam format JSON
      final Map<String, dynamic> data = {
        'name_product': _nameController.text,
        'code_product': _codeController.text,
        'selling_price': _sellingPriceController.text,
        'purchase_price': _purchasePriceController.text,
        'stock': _stockController.text,
        'unit': _unitController.text,
        'store_id': _selectedStoreId.toString(),
        'category_product_id': _selectedCategoryId.toString(),
      };

      if (widget.product != null) {
        // Update produk
        final response = await http.put(
          Uri.parse('${Config.apiUrl}/products/${widget.product!['id']}'),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: json.encode(data),
        );

        if (response.statusCode == 200) {
          // Jika ada gambar baru, upload gambar
          if (_imageFile != null) {
            await _uploadImage(token!, widget.product!['id']);
          }
          showCustomSnackBar(
              context, 'Produk berhasil diperbarui', SnackBarType.success);
        } else {
          throw Exception('Gagal memperbarui produk');
        }
      } else {
        // Create produk baru
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('${Config.apiUrl}/products'),
        );

        request.headers['Authorization'] = 'Bearer $token';
        request.headers['Accept'] = 'application/json';

        request.fields.addAll({
          'name': _nameController.text,
          'code_product': _codeController.text,
          'selling_price': _sellingPriceController.text,
          'purchase_price': _purchasePriceController.text,
          'stock': _stockController.text,
          'unit': _unitController.text,
          'store_id': _selectedStoreId.toString(),
          'category_product_id': _selectedCategoryId.toString(),
        });

        // if (_imag != null) {
        //   request.files.add(await http.MultipartFile.fromPath(
        //     'image',
        //     _selectedImage!.path,
        //   ));
        // }

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode != 201) {
          final responseData = json.decode(response.body);
          throw Exception(responseData['message'] ?? 'Gagal menambahkan toko');
        }
      }

      Navigator.pop(context);
    } catch (e) {
      showCustomSnackBar(context, 'Gagal menyimpan produk: ${e.toString()}',
          SnackBarType.error);
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _uploadImage(String token, String productId) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${Config.apiUrl}/products/$productId/image'),
    );

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    request.files.add(await http.MultipartFile.fromPath(
      'image',
      _imageFile!.path,
    ));

    final response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Gagal mengupload gambar');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product != null ? 'Edit Produk' : 'Tambah Produk'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Input File Gambar
                  FileInput(
                    label: 'Gambar Produk',
                    hintText: 'Pilih gambar produk',
                    isRequired: false,
                    initialValue: widget.product?['image_url'],
                    onFileSelected: (file) {
                      setState(() => _imageFile = file);
                    },
                    isImage: true,
                  ),
                  SizedBox(height: 16),

                  // Form Fields
                  LabeledInput(
                    label: 'Nama Produk',
                    controller: _nameController,
                    isRequired: true,
                  ),
                  LabeledInput(
                    label: 'Kode Produk',
                    controller: _codeController,
                    isRequired: true,
                  ),
                  LabeledInput(
                    label: 'Harga Jual',
                    controller: _sellingPriceController,
                    isRequired: true,
                    keyboardType: TextInputType.number,
                  ),
                  LabeledInput(
                    label: 'Harga Beli',
                    controller: _purchasePriceController,
                    isRequired: true,
                    keyboardType: TextInputType.number,
                  ),
                  LabeledInput(
                    label: 'Stok',
                    controller: _stockController,
                    isRequired: true,
                    keyboardType: TextInputType.number,
                  ),
                  LabeledInput(
                    label: 'Satuan',
                    controller: _unitController,
                    isRequired: true,
                  ),

                  // Dropdown Toko
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
                  ),

                  // Dropdown Kategori
                  CustomDropdown(
                    label: 'Kategori',
                    hint: 'Pilih Kategori',
                    value: _selectedCategoryId?.toString(),
                    items: categories.map((category) {
                      return {
                        'value': category['id'].toString(),
                        'label': category['name'].toString(),
                      };
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedCategoryId = int.parse(value!));
                    },
                    isRequired: true,
                  ),

                  SizedBox(height: 24),
                  Button(
                    text: widget.product != null
                        ? 'Simpan Perubahan'
                        : 'Tambah Produk',
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
