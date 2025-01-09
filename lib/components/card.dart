import 'package:flutter/material.dart';

class StoreCard extends StatelessWidget {
  final String name;
  final String numberPhone;
  final String postalCode;
  final String address;
  final String? urlImage;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const StoreCard({
    Key? key,
    required this.name,
    required this.numberPhone,
    required this.postalCode,
    required this.address,
    this.urlImage,
    this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Store Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: urlImage != null
                  ? Image.network(
                      urlImage!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 150,
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.store,
                          size: 50,
                          color: Colors.grey[400],
                        ),
                      ),
                    )
                  : Container(
                      height: 150,
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.store,
                        size: 50,
                        color: Colors.grey[400],
                      ),
                    ),
            ),

            // Store Information
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Store Name and Actions
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          if (onEdit != null)
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: onEdit,
                              tooltip: 'Edit Store',
                            ),
                          if (onDelete != null)
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Delete Store'),
                                    content: Text(
                                        'Are you sure you want to delete this store?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          onDelete?.call();
                                        },
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              tooltip: 'Delete Store',
                            ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),

                  // Phone Number
                  Row(
                    children: [
                      Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                      SizedBox(width: 8),
                      Text(
                        numberPhone,
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),

                  // Postal Code
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 16, color: Colors.grey[600]),
                      SizedBox(width: 8),
                      Text(
                        'Postal Code: $postalCode',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),

                  // Address
                  Row(
                    children: [
                      Icon(Icons.home, size: 16, color: Colors.grey[600]),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          address,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Grid view untuk menampilkan multiple store cards
class StoreGrid extends StatelessWidget {
  final List<Map<String, dynamic>> stores;
  final Function(Map<String, dynamic>)? onStoreSelected;
  final Function(Map<String, dynamic>)? onEditStore;
  final Function(Map<String, dynamic>)? onDeleteStore;

  const StoreGrid({
    Key? key,
    required this.stores,
    this.onStoreSelected,
    this.onEditStore,
    this.onDeleteStore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
        childAspectRatio: 1.2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: stores.length,
      itemBuilder: (context, index) {
        final store = stores[index];
        return StoreCard(
          name: store['name'],
          numberPhone: store['number_phone'],
          postalCode: store['postal_code'],
          address: store['address'],
          urlImage: store['url_image'],
          onTap: () => onStoreSelected?.call(store),
          onEdit: () => onEditStore?.call(store),
          onDelete: () => onDeleteStore?.call(store),
        );
      },
    );
  }
}

// staff card
import 'package:flutter/material.dart';

class StaffCard extends StatelessWidget {
  final int storeId;
  final int userId;
  final String role;
  final String name;
  final String email;
  final String numberPhone;
  final String? imageUrl;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const StaffCard({
    Key? key,
    required this.storeId,
    required this.userId,
    required this.role,
    required this.name,
    required this.email,
    required this.numberPhone,
    this.imageUrl,
    this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  Color _getRoleColor() {
    switch (role.toLowerCase()) {
      case 'owner':
        return Colors.orange;
      case 'staff':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _getRoleColor(),
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.grey[400],
                          ),
                        )
                      : CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : '?',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                ),
              ),
              SizedBox(width: 16),

              // Staff Information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Role
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getRoleColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            role.toUpperCase(),
                            style: TextStyle(
                              color: _getRoleColor(),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),

                    // Email
                    Row(
                      children: [
                        Icon(
                          Icons.email_outlined,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            email,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),

                    // Phone Number
                    Row(
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 4),
                        Text(
                          numberPhone,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Action Buttons
              Column(
                children: [
                  if (onEdit != null)
                    IconButton(
                      icon: Icon(
                        Icons.edit_outlined,
                        color: Colors.blue,
                        size: 20,
                      ),
                      onPressed: onEdit,
                      tooltip: 'Edit Staff',
                    ),
                  if (onDelete != null)
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 20,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Delete Staff'),
                            content: Text(
                                'Are you sure you want to delete this staff member?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  onDelete?.call();
                                },
                                child: Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      tooltip: 'Delete Staff',
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Staff List Component
class StaffList extends StatelessWidget {
  final List<Map<String, dynamic>> staffList;
  final Function(Map<String, dynamic>)? onStaffSelected;
  final Function(Map<String, dynamic>)? onEditStaff;
  final Function(Map<String, dynamic>)? onDeleteStaff;

  const StaffList({
    Key? key,
    required this.staffList,
    this.onStaffSelected,
    this.onEditStaff,
    this.onDeleteStaff,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: staffList.length,
      itemBuilder: (context, index) {
        final staff = staffList[index];
        return StaffCard(
          storeId: staff['store_id'],
          userId: staff['user_id'],
          role: staff['role'],
          name: staff['name'],
          email: staff['email'],
          numberPhone: staff['number_phone'],
          imageUrl: staff['image_url'],
          onTap: () => onStaffSelected?.call(staff),
          onEdit: () => onEditStaff?.call(staff),
          onDelete: () => onDeleteStaff?.call(staff),
        );
      },
    );
  }
}


import 'package:flutter/material.dart';

enum ContactType { customer, supplier }

class ContactCard extends StatelessWidget {
  final int storeId;
  final String name;
  final String numberPhone;
  final String address;
  final String email;
  final ContactType type;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ContactCard({
    Key? key,
    required this.storeId,
    required this.name,
    required this.numberPhone,
    required this.address,
    required this.email,
    required this.type,
    this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  Color _getTypeColor() {
    return type == ContactType.customer ? Colors.blue : Colors.green;
  }

  String get _typeText => type == ContactType.customer ? 'Customer' : 'Supplier';

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _getTypeColor().withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            // Header with type indicator
            Container(
              decoration: BoxDecoration(
                color: _getTypeColor().withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        type == ContactType.customer
                            ? Icons.person
                            : Icons.local_shipping,
                        color: _getTypeColor(),
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        _typeText,
                        style: TextStyle(
                          color: _getTypeColor(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      if (onEdit != null)
                        IconButton(
                          icon: Icon(
                            Icons.edit_outlined,
                            color: Colors.blue,
                            size: 20,
                          ),
                          onPressed: onEdit,
                          tooltip: 'Edit',
                        ),
                      if (onDelete != null)
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                            size: 20,
                          ),
                          onPressed: () => _showDeleteDialog(context),
                          tooltip: 'Delete',
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Contact Information
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12),

                  // Contact Details
                  ContactInfoRow(
                    icon: Icons.email_outlined,
                    text: email,
                    copyable: true,
                  ),
                  SizedBox(height: 8),
                  ContactInfoRow(
                    icon: Icons.phone_outlined,
                    text: numberPhone,
                    copyable: true,
                  ),
                  SizedBox(height: 8),
                  ContactInfoRow(
                    icon: Icons.location_on_outlined,
                    text: address,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${_typeText}'),
        content: Text('Are you sure you want to delete this ${_typeText.toLowerCase()}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete?.call();
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class ContactInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool copyable;

  const ContactInfoRow({
    Key? key,
    required this.icon,
    required this.text,
    this.copyable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 14,
            ),
            maxLines: icon == Icons.location_on_outlined ? 2 : 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (copyable)
          IconButton(
            icon: Icon(
              Icons.copy,
              size: 16,
              color: Colors.grey[600],
            ),
            onPressed: () {
              // Copy to clipboard functionality
              // You'll need to add the clipboard package
              // Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Copied to clipboard'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            tooltip: 'Copy to clipboard',
          ),
      ],
    );
  }
}

// Contact List Component
class ContactList extends StatelessWidget {
  final List<Map<String, dynamic>> contacts;
  final ContactType type;
  final Function(Map<String, dynamic>)? onContactSelected;
  final Function(Map<String, dynamic>)? onEditContact;
  final Function(Map<String, dynamic>)? onDeleteContact;

  const ContactList({
    Key? key,
    required this.contacts,
    required this.type,
    this.onContactSelected,
    this.onEditContact,
    this.onDeleteContact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return ContactCard(
          storeId: contact['store_id'],
          name: contact['name'],
          numberPhone: contact['number_phone'],
          address: contact['address'],
          email: contact['email'],
          type: type,
          onTap: () => onContactSelected?.call(contact),
          onEdit: () => onEditContact?.call(contact),
          onDelete: () => onDeleteContact?.call(contact),
        );
      },
    );
  }
}
