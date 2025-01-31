import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class FileInput extends StatelessWidget {
  final String label;
  final String? hintText;
  final bool isRequired;
  final String? errorText;
  final Function(File) onFileSelected;
  final String? initialValue;
  final bool isImage;

  const FileInput({
    Key? key,
    required this.label,
    this.hintText,
    this.isRequired = false,
    this.errorText,
    required this.onFileSelected,
    this.initialValue,
    this.isImage = true,
  }) : super(key: key);

  Future<void> _pickFile(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
      );

      if (pickedFile != null) {
        onFileSelected(File(pickedFile.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memilih file'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label dengan tanda required jika diperlukan
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (isRequired)
                Text(
                  ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          SizedBox(height: 8),
          // Container untuk input file
          InkWell(
            onTap: () => _pickFile(context),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.file_upload, color: Colors.grey),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      initialValue ?? hintText ?? 'Pilih file',
                      style: TextStyle(
                        color:
                            initialValue != null ? Colors.black : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                errorText!,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
          if (initialValue != null && isImage)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Image.network(
                initialValue!,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 100,
                    width: 100,
                    color: Colors.grey[300],
                    child: Icon(Icons.error),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
