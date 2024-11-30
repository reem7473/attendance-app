import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/faculty_bloc/auth/faculty_auth_cubit.dart';
import '../../../blocs/faculty_bloc/auth/faculty_auth_states.dart';


class EditUniversityDialog extends StatefulWidget {
  final int id;
  final String universityName;
  final String collegeName;
  final String specialization;

  EditUniversityDialog({
    required this.id,
    required this.universityName,
    required this.collegeName,
    required this.specialization,
  });

  @override
  _EditUniversityDialogState createState() => _EditUniversityDialogState();
}

class _EditUniversityDialogState extends State<EditUniversityDialog> {
  late TextEditingController universityNameController;
  late TextEditingController collegeController;
  late TextEditingController majorController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    universityNameController = TextEditingController(text: widget.universityName);
    collegeController = TextEditingController(text: widget.collegeName);
    majorController = TextEditingController(text: widget.specialization);
  }

  @override
  void dispose() {
    universityNameController.dispose();
    collegeController.dispose();
    majorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('تعديل بيانات الجامعة'),
      content: BlocConsumer<FacultyAuthCubit, FacultyAuthState>(
        listener: (context, state) {
          if (state is AuthUpdatedFacultyStudyInfo) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('تم تحديث البيانات بنجاح')),
            );
            Navigator.of(context).pop(); // إغلاق الحوار بعد النجاح
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('حدث خطأ: ${state.error}')),
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: universityNameController,
                  decoration: InputDecoration(labelText: 'اسم الجامعة'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال اسم الجامعة';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: collegeController,
                  decoration: InputDecoration(labelText: 'الكلية'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال اسم الكلية';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: majorController,
                  decoration: InputDecoration(labelText: 'التخصص'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال التخصص';
                    }
                    return null;
                  },
                ),
              ],
            ),
          );
        },
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
              final universityName = universityNameController.text;
              final college = collegeController.text;
              final major = majorController.text;

              final authCubit = context.read<FacultyAuthCubit>();

              authCubit.updateFacultyStudyInfo(
                widget.id,
              {
                'university_name': universityName,
                'college': college,
                'major': major,
              }
              );
            }
          },
          child: Text('حفظ التعديل'),
        ),
      ],
    );
  }
}
