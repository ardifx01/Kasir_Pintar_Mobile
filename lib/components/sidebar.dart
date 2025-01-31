import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kasir_pintar/config.dart';

class Sidebar extends StatefulWidget {
  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  String? userRole;
  Map<String, dynamic>? profile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserRole();
    getProfile();
  }

  Future<void> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('user_role') ?? '';
    });
  }

  Future<void> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    try {
      final response = await http.get(
        Uri.parse('${Config.apiUrl}/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          profile = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          profile = null;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        profile = null;
        isLoading = false;
      });
    }
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
            child: isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.white))
                : profile != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: profile!['url_image'] != null
                                ? NetworkImage(
                                    '${Config.imageUrl}/${profile!['url_image']}')
                                : null,
                            child: profile!['url_image'] == null
                                ? Icon(Icons.person,
                                    size: 40, color: Colors.white)
                                : null,
                          ),
                          SizedBox(height: 10),
                          Text(
                            profile!['name'] ?? 'Nama tidak tersedia',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      )
                    : ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/profile/create');
                        },
                        child: Text('Lengkapi Profil'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue,
                        ),
                      ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashboard'),
            onTap: () => Navigator.pushReplacementNamed(context, '/dashboard'),
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Transaction'),
            onTap: () => Navigator.pushNamed(context, '/transaction'),
          ),
          ListTile(
            leading: Icon(Icons.inventory),
            title: Text('Product'),
            onTap: () => Navigator.pushNamed(context, '/product'),
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Customer & Supplier'),
            onTap: () => Navigator.pushNamed(context, '/customer-supplier'),
          ),
          if (userRole == 'owner')
            ListTile(
              leading: Icon(Icons.store),
              title: Text('Manajemen Toko'),
              onTap: () => Navigator.pushNamed(context, '/store-management'),
            ),
          ListTile(
            leading: Icon(Icons.assessment),
            title: Text('Laporan'),
            onTap: () => Navigator.pushNamed(context, '/report'),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Setting'),
            onTap: () => Navigator.pushNamed(context, '/settings'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
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
    );
  }
}

// Cara menggunakan sidebar di Scaffold:
