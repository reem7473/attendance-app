import 'package:flutter/material.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('تأكيد الخروج'),
      content: Text('هل أنت متأكد من أنك تريد تسجيل الخروج؟'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('تسجيل الخروج'),
        ),
      ],
    );
  }
}
