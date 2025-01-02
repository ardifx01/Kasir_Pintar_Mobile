import 'package:flutter/material.dart';

class LabeledInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hintText;

  const LabeledInput({
    Key? key,
    required this.label,
    required this.controller,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}

class PasswordInput extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? hintText;

  const PasswordInput({
    Key? key,
    required this.label,
    required this.controller,
    this.hintText,
  }) : super(key: key);

  @override
  _PasswordInputState createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: widget.controller,
            obscureText: _isObscure,
            decoration: InputDecoration(
              hintText: widget.hintText,
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
