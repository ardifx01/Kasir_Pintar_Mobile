import 'package:flutter/material.dart';

enum ButtonStyleType { green, yellow, red, black }

class Button extends StatelessWidget {
  final String text;
  final ButtonStyleType styleType;
  final dynamic onPressed;

  const Button({
    Key? key,
    required this.text,
    required this.styleType,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(_getButtonColor(styleType)),
          padding:
              MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 16.0)),
        ),
        onPressed: onPressed == null
            ? null
            : () async {
                if (onPressed is Future Function()) {
                  await onPressed();
                } else {
                  onPressed();
                }
              },
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
      case ButtonStyleType.black:
        return Colors.black;
      default:
        return Colors.blue;
    }
  }
}
