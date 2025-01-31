import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kasir_pintar/config.dart';
import 'package:kasir_pintar/components/input.dart';
import 'package:kasir_pintar/components/button.dart';
import 'package:kasir_pintar/components/snackbar.dart';
import 'package:kasir_pintar/components/dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

class POSView extends StatefulWidget {
  @override
  _POSViewState createState() => _POSViewState();
}

class _POSViewState extends State<POSView> {
  final _formKey = GlobalKey<FormState>();
  final _totalDiscountController = TextEditingController();
  final _amountPaidController = TextEditingController();
  final _descriptionController = TextEditingController();
  List<Map<String, dynamic>> sellingDetails = [];
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> stores = [];
  bool isLoading = false;
  String? selectedStoreId;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
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
        throw Exception('Gagal memuat toko');
      }
    } catch (e) {
      showCustomSnackBar(
          context, 'Gagal memuat toko: ${e.toString()}', SnackBarType.error);
    }
  }

  Future<void> _fetchProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final response = await http.get(
        Uri.parse('${Config.apiUrl}/products'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          products = List<Map<String, dynamic>>.from(data);
        });
      } else {
        throw Exception('Gagal memuat produk');
      }
    } catch (e) {
      showCustomSnackBar(
          context, 'Gagal memuat produk: ${e.toString()}', SnackBarType.error);
    }
  }

  void _addProductToTransaction(Map<String, dynamic> product) {
    final existingProduct = sellingDetails.firstWhere(
      (item) => item['product_id'] == product['id'],
      orElse: () => {},
    );

    if (existingProduct.isNotEmpty) {
      setState(() {
        existingProduct['quantity']++;
        existingProduct['subtotal'] = existingProduct['quantity'] *
            double.parse(product['selling_price']);
      });
    } else {
      setState(() {
        sellingDetails.add({
          'product_id': product['id'],
          'quantity': 1,
          'item_discount': 0,
          'subtotal': double.parse(product['selling_price']),
        });
      });
    }
  }

  void _removeProductFromTransaction(Map<String, dynamic> product) {
    final existingProduct = sellingDetails.firstWhere(
      (item) => item['product_id'] == product['id'],
      orElse: () => {},
    );

    if (existingProduct.isNotEmpty) {
      setState(() {
        if (existingProduct['quantity'] > 1) {
          existingProduct['quantity']--;
          existingProduct['subtotal'] = existingProduct['quantity'] *
              double.parse(product['selling_price']);
        } else {
          sellingDetails.remove(existingProduct);
        }
      });
    }
  }

  double _calculateTotalAmount() {
    double total = 0;
    for (var item in sellingDetails) {
      total += item['subtotal'];
    }
    double discount = double.tryParse(_totalDiscountController.text) ?? 0;
    return total - discount;
  }

  Future<void> _submitTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      double totalAmount = _calculateTotalAmount();
      double amountPaid = double.tryParse(_amountPaidController.text) ?? 0;

      final Map<String, dynamic> transactionData = {
        'store_id': selectedStoreId,
        'total_discount': double.tryParse(_totalDiscountController.text) ?? 0,
        'total_amount': totalAmount,
        'amount_paid': amountPaid,
        'change_amount': amountPaid - totalAmount,
        'description': _descriptionController.text,
        'sellingDetailTransactions': sellingDetails,
      };

      final response = await http.post(
        Uri.parse('${Config.apiUrl}/transactions/selling'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(transactionData),
      );

      if (response.statusCode == 201) {
        showCustomSnackBar(
            context, 'Transaksi berhasil dibuat', SnackBarType.success);
        _resetForm();
      } else {
        throw Exception('Gagal membuat transaksi');
      }
    } catch (e) {
      showCustomSnackBar(context, 'Gagal menyimpan transaksi: ${e.toString()}',
          SnackBarType.error);
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _resetForm() {
    _totalDiscountController.clear();
    _amountPaidController.clear();
    _descriptionController.clear();
    sellingDetails.clear();
    selectedStoreId = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Point of Sale'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomDropdown(
                    label: 'Pilih Toko',
                    hint: 'Pilih toko',
                    items: stores.map((store) {
                      return {
                        'value': store['id'].toString(),
                        'label': store['name'],
                      };
                    }).toList(),
                    value: selectedStoreId?.toString(),
                    onChanged: (value) {
                      setState(() {
                        selectedStoreId =
                            value != null ? int.parse(value).toString() : null;
                      });
                    },
                    isRequired: true,
                    errorText:
                        selectedStoreId == null ? 'Toko harus dipilih' : null,
                  ),
                  LabeledInput(
                    label: 'Total Discount',
                    controller: _totalDiscountController,
                    isRequired: true,
                    keyboardType: TextInputType.number,
                  ),
                  LabeledInput(
                    label: 'Amount Paid',
                    controller: _amountPaidController,
                    isRequired: true,
                    keyboardType: TextInputType.number,
                  ),
                  LabeledInput(
                    label: 'Description',
                    controller: _descriptionController,
                    isRequired: false,
                  ),
                  SizedBox(height: 24),
                  Text('Daftar Produk:', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ListTile(
                        title: Text(product['name_product']),
                        subtitle: Text('Harga: ${product['selling_price']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () =>
                                  _removeProductFromTransaction(product),
                            ),
                            Text(sellingDetails
                                .firstWhere(
                                  (item) => item['product_id'] == product['id'],
                                  orElse: () => {'quantity': 0},
                                )['quantity']
                                .toString()),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () =>
                                  _addProductToTransaction(product),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 24),
                  Text('Total: ${_calculateTotalAmount()}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 24),
                  Button(
                    text: 'Buat Transaksi',
                    styleType: ButtonStyleType.green,
                    onPressed: isLoading ? null : _submitTransaction,
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
