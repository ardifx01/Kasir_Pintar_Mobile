import 'package:flutter/material.dart';

enum ButtonStyleType { green, yellow, red }

class Button extends StatelessWidget {
  final String text;
  final ButtonStyleType styleType;
  final VoidCallback onPressed;

  const Button({
    Key? key,
    required this.text,
    required this.styleType,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Memenuhi lebar layar
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(_getButtonColor(styleType)),
          padding:
              WidgetStateProperty.all(EdgeInsets.symmetric(vertical: 16.0)),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Color _getButtonColor(ButtonStyleType type) {
    switch (type) {
      case ButtonStyleType.green:
        return Colors.green;
      case ButtonStyleType.yellow:
        return Colors.yellow;
      case ButtonStyleType.red:
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}
