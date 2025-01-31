import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatelessWidget {
  final int id;
  final String name;
  final String code;
  final double sellingPrice;
  final double purchasePrice;
  final int stock;
  final String unit;
  final String? imageUrl;
  final String storeName;
  final String categoryName;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProductCard({
    Key? key,
    required this.id,
    required this.name,
    required this.code,
    required this.sellingPrice,
    required this.purchasePrice,
    required this.stock,
    required this.unit,
    this.imageUrl,
    required this.storeName,
    required this.categoryName,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          if (imageUrl != null)
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                image: DecorationImage(
                  image: NetworkImage(imageUrl!),
                  fit: BoxFit.cover,
                ),
              ),
            ),

          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name and Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (onEdit != null || onDelete != null)
                      Row(
                        children: [
                          if (onEdit != null)
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: onEdit,
                            ),
                          if (onDelete != null)
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: onDelete,
                            ),
                        ],
                      ),
                  ],
                ),

                // Product Code
                Text(
                  'Kode: $code',
                  style: TextStyle(color: Colors.grey[600]),
                ),

                SizedBox(height: 8),

                // Prices
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Harga Jual',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Text(
                          currencyFormat.format(sellingPrice),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Harga Beli',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Text(
                          currencyFormat.format(purchasePrice),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 8),

                // Stock and Unit
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Stok: $stock $unit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(categoryName),
                    ),
                  ],
                ),

                SizedBox(height: 8),

                // Store
                Row(
                  children: [
                    Icon(Icons.store, size: 16, color: Colors.grey[600]),
                    SizedBox(width: 4),
                    Text(
                      storeName,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
