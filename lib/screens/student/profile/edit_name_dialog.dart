import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/profile_cubit.dart';
import 'bloc/profile_state.dart';

class EditNameDialog extends StatefulWidget {
  final int studentId;

  const EditNameDialog({super.key, required this.studentId});

  @override
  _EditNameDialogState createState() => _EditNameDialogState();
}

class _EditNameDialogState extends State<EditNameDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileStudentCubit, ProfileStudentState>(
      listener: (context, state) {
        if (state is ProfileLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم تحديث الاسم بنجاح')),
          );
          Navigator.of(context).pop(); // Close dialog
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: AlertDialog(
        title: const Text('تغيير الاسم'),
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'الاسم الجديد'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'برجاء إدخال الاسم الجديد';
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
                context.read<ProfileStudentCubit>().updateName(widget.studentId, _nameController.text);
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
}
