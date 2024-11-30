import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/profile_cubit.dart';
import 'bloc/profile_state.dart';

class EditPhoneDialog extends StatefulWidget {
  final int facultyId;

  const EditPhoneDialog({super.key, required this.facultyId});

  @override
  _EditPhoneDialogState createState() => _EditPhoneDialogState();
}

class _EditPhoneDialogState extends State<EditPhoneDialog> {
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
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم تحديث رقم الجوال بنجاح')),
          );
          Navigator.of(context).pop(); // Close dialog
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: AlertDialog(
        title: const Text('تغيير رقم الجوال'),
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(labelText: 'رقم الجوال الجديد'),
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
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<ProfileCubit>().updatePhoneNumber(widget.facultyId, _phoneController.text);
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
}
