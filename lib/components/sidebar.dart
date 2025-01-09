import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sidebar extends StatefulWidget {
  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  String? userRole;

  @override
  void initState() {
    super.initState();
    getUserRole();
  }

  Future<void> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole =
          prefs.getString('role') ?? ''; // Ambil role dari SharedPreferences
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png', // Sesuaikan dengan path logo Anda
                  height: 80,
                ),
                SizedBox(height: 10),
                Text(
                  'Nama Aplikasi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashboard'),
            onTap: () {
              // Navigasi ke halaman Dashboard
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Transaction'),
            onTap: () {
              // Navigasi ke halaman Transaction
            },
          ),
          ListTile(
            leading: Icon(Icons.inventory),
            title: Text('Product'),
            onTap: () {
              // Navigasi ke halaman Product
            },
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Customer & Supplier'),
            onTap: () {
              // Navigasi ke halaman Customer & Supplier
            },
          ),
          if (userRole == 'owner') // Hanya tampilkan jika role adalah owner
            ListTile(
              leading: Icon(Icons.store),
              title: Text('Manajemen Toko'),
              onTap: () {
                // Navigasi ke halaman Manajemen Toko
              },
            ),
          ListTile(
            leading: Icon(Icons.assessment),
            title: Text('Laporan'),
            onTap: () {
              // Navigasi ke halaman Laporan
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Setting'),
            onTap: () {
              // Navigasi ke halaman Setting
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Logout'),
                  content: Text('Apakah Anda yakin ingin keluar?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.clear();
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                      child: Text('Ya'),
                    ),
                  ],
                ),
              ); // Navigasi ke halaman login
            },
          ),
        ],
      ),
    );
  }
}

// Cara menggunakan sidebar di Scaffold:
