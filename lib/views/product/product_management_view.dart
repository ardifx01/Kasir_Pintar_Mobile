import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kasir_pintar/config.dart';
import 'package:kasir_pintar/components/product_card.dart';
import 'package:kasir_pintar/components/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductManagementView extends StatefulWidget {
  @override
  _ProductManagementViewState createState() => _ProductManagementViewState();
}

class _ProductManagementViewState extends State<ProductManagementView> {
  List<Map<String, dynamic>> products = [];
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
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final url = storeId != null
          ? '${Config.apiUrl}/products/store/$storeId'
          : '${Config.apiUrl}/products';

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
          products = List<Map<String, dynamic>>.from(data);
          isLoading = false;
        });
      } else {
        throw Exception('Gagal memuat data produk');
      }
    } catch (e) {
      setState(() => isLoading = false);
      showCustomSnackBar(context, e.toString(), SnackBarType.error);
    }
  }

  Future<void> _handleDeleteProduct(Map<String, dynamic> product) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final response = await http.delete(
        Uri.parse('${Config.apiUrl}/products/${product['id']}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        showCustomSnackBar(
          context,
          'Produk berhasil dihapus',
          SnackBarType.success,
        );
        fetchProducts();
      } else {
        throw Exception('Gagal menghapus produk');
      }
    } catch (e) {
      showCustomSnackBar(context, e.toString(), SnackBarType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manajemen Produk'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/product/create')
            .then((_) => fetchProducts()),
        child: Icon(Icons.add),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  id: product['id'],
                  name: product['name_product'],
                  code: product['code_product'],
                  sellingPrice:
                      double.parse(product['selling_price'].toString()),
                  purchasePrice:
                      double.parse(product['purchase_price'].toString()),
                  stock: product['stock'],
                  unit: product['unit'],
                  imageUrl: product['image_url'],
                  storeName: product['store']['name'],
                  categoryName: product['category_product']['name'],
                  onEdit: () {
                    Navigator.pushNamed(
                      context,
                      '/product/edit',
                      arguments: product,
                    ).then((_) => fetchProducts());
                  },
                  onDelete: () => _handleDeleteProduct(product),
                );
              },
            ),
    );
  }
}
