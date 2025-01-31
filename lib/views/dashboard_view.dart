import 'package:flutter/material.dart';
import 'package:kasir_pintar/components/sidebar.dart';
import 'package:kasir_pintar/components/menu_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardView extends StatefulWidget {
  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  String? userRole;
  final List<Map<String, dynamic>> menuItems = [
    {
      'title': 'Laporan',
      'imagePath': 'assets/icons/report.png',
      'routeName': '/report',
      'color': Colors.blue,
      'roles': ['owner', 'admin', 'staff'],
    },
    {
      'title': 'Transaksi Penjualan',
      'imagePath': 'assets/icons/sales.png',
      'routeName': '/pos',
      'color': Colors.green,
      'roles': ['owner', 'admin', 'staff'],
    },
    {
      'title': 'Transaksi Pembelian',
      'imagePath': 'assets/icons/purchase.png',
      'routeName': '/purchase',
      'color': Colors.orange,
      'roles': ['owner', 'admin', 'staff'],
    },
    {
      'title': 'Produk',
      'imagePath': 'assets/icons/product.png',
      'routeName': '/product',
      'color': Colors.purple,
      'roles': ['owner', 'admin', 'staff'],
    },
    {
      'title': 'Pelanggan',
      'imagePath': 'assets/icons/customer.png',
      'routeName': '/customer',
      'color': Colors.teal,
      'roles': ['owner', 'admin', 'staff'],
    },
    {
      'title': 'Supplier',
      'imagePath': 'assets/icons/supplier.png',
      'routeName': '/supplier',
      'color': Colors.indigo,
      'roles': ['owner', 'admin', 'staff'],
    },
    {
      'title': 'Manajemen Toko',
      'imagePath': 'assets/icons/store.png',
      'routeName': '/store',
      'color': Colors.red,
      'roles': ['owner', 'admin'],
    },
    {
      'title': 'Manajemen Staff',
      'imagePath': 'assets/icons/staff.png',
      'routeName': '/staff',
      'color': Colors.brown,
      'roles': ['owner', 'admin'],
    },
    {
      'title': 'Pengaturan',
      'imagePath': 'assets/icons/settings.png',
      'routeName': '/settings',
      'color': Colors.grey,
      'roles': ['owner', 'admin', 'staff'],
    },
  ];

  @override
  void initState() {
    super.initState();
    getUserRole();
  }

  Future<void> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('user_role') ?? 'staff';
    });
  }

  List<Map<String, dynamic>> get filteredMenuItems {
    if (userRole == null) return [];
    return menuItems.where((menu) => menu['roles'].contains(userRole)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat Datang',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Pilih menu di bawah ini untuk memulai',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: filteredMenuItems.length,
                itemBuilder: (context, index) {
                  final menu = filteredMenuItems[index];
                  return MenuCard(
                    title: menu['title'],
                    imagePath: menu['imagePath'],
                    routeName: menu['routeName'],
                    color: menu['color'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
