import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/faculty_bloc/auth/faculty_auth_cubit.dart';
import '../../../blocs/faculty_bloc/auth/faculty_auth_states.dart';

class AddCourseDialogSub extends StatelessWidget {
  final int facultyStudyInfoId;

  AddCourseDialogSub({required this.facultyStudyInfoId});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController courseNameController = TextEditingController();
  final TextEditingController levelController = TextEditingController();
  final TextEditingController sectionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('إضافة مقرر'),
      content: BlocConsumer<FacultyAuthCubit, FacultyAuthState>(
        listener: (context, state) {
          if (state is AuthAddCourseSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('تم إضافة المقرر بنجاح')),
            );
            Navigator.of(context).pop();
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
                  controller: courseNameController,
                  decoration: InputDecoration(labelText: 'اسم المقرر'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال اسم المقرر';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: levelController,
                  decoration: InputDecoration(labelText: 'المستوى'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال المستوى';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: sectionController,
                  decoration: InputDecoration(labelText: 'الشعبة'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال الشعبة';
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
              final courseName = courseNameController.text;
              final level = levelController.text;
              final section = sectionController.text;

              final authCubit = context.read<FacultyAuthCubit>();

              authCubit.addCourse(
                facultyStudyInfoId,
                {
                  'course_name': courseName,
                  'level': level,
                  'section': section,
                },
              );
            }
          },
          child: Text('إضافة'),
        ),
      ],
    );
  }
}
