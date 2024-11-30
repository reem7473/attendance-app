import 'package:flutter/material.dart';
import '../functions/network_util.dart';

class NetworkSensitiveButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;

  NetworkSensitiveButton({required this.onPressed, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        bool isConnected = await checkInternetConnection();
        if (isConnected) {
          onPressed();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'لا يوجد اتصال بالإنترنت. يرجى التحقق من الاتصال والمحاولة مرة أخرى.')),
          );
        }
      },
      child: Text(buttonText),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 10),
        textStyle: TextStyle(fontSize: 16),
      ),
    );
  }
}
