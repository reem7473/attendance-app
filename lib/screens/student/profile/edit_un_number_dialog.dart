import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/profile_cubit.dart';
import 'bloc/profile_state.dart';

class EditUnNumberDialog extends StatefulWidget {
  final int studentId;

  const EditUnNumberDialog({super.key, required this.studentId});

  @override
  _EditUnNumberDialogState createState() => _EditUnNumberDialogState();
}

class _EditUnNumberDialogState extends State<EditUnNumberDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileStudentCubit, ProfileStudentState>(
      listener: (context, state) {
        if (state is ProfileLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم تحديث الرقم الجامعي بنجاح')),
          );
          Navigator.of(context).pop(); 
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: AlertDialog(
        title: Text('تغيير الرقم الجامعي'),
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(labelText: 'الرقم الجامعي الجديد'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'برجاء إدخال رقم الجوال الجديد';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<ProfileStudentCubit>().updatePhoneNumber(widget.studentId, _phoneController.text);
              }
            },
            child: Text('حفظ'),
          ),
        ],
      ),
    );
  }
}
