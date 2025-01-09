import 'package:flutter/material.dart';

class CustomDataTable extends StatelessWidget {
  final List<String> columns;
  final List<Map<String, dynamic>> rows;
  final Function(Map<String, dynamic>)? onEdit;
  final Function(Map<String, dynamic>)? onDelete;
  final Function(Map<String, dynamic>)? onView;
  final bool isLoading;
  final bool showActions;
  final List<Widget> Function(Map<String, dynamic>)? customActions;
  final ScrollController? scrollController;

  const CustomDataTable({
    Key? key,
    required this.columns,
    required this.rows,
    this.onEdit,
    this.onDelete,
    this.onView,
    this.isLoading = false,
    this.showActions = true,
    this.customActions,
    this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    ...columns.map(
                      (column) => Container(
                        width: 150, // Adjust width as needed
                        padding: EdgeInsets.all(16),
                        child: Text(
                          column,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    if (showActions)
                      Container(
                        width: 150, // Width for actions column
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Actions',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Loading indicator
              if (isLoading)
                Container(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),

              // No data message
              if (!isLoading && rows.isEmpty)
                Container(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

              // Table rows
              if (!isLoading && rows.isNotEmpty)
                ...rows.map((row) => Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey[200]!,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          ...columns.map(
                            (column) => Container(
                              width: 150, // Adjust width as needed
                              padding: EdgeInsets.all(16),
                              child: Text(
                                row[column]?.toString() ?? '',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          if (showActions)
                            Container(
                              width: 150, // Width for actions column
                              padding: EdgeInsets.all(16),
                              child: Row(
                                children: customActions != null
                                    ? customActions!(row)
                                    : _buildDefaultActions(row, context),
                              ),
                            ),
                        ],
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDefaultActions(
      Map<String, dynamic> row, BuildContext context) {
    return [
      if (onView != null)
        IconButton(
          icon: Icon(Icons.visibility, color: Colors.blue),
          onPressed: () => onView!(row),
          tooltip: 'View',
        ),
      if (onEdit != null)
        IconButton(
          icon: Icon(Icons.edit, color: Colors.green),
          onPressed: () => onEdit!(row),
          tooltip: 'Edit',
        ),
      if (onDelete != null)
        IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => _showDeleteConfirmation(context, row),
          tooltip: 'Delete',
        ),
    ];
  }

  void _showDeleteConfirmation(BuildContext context, Map<String, dynamic> row) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete!(row);
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
