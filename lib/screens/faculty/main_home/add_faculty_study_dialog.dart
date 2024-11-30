import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/faculty_bloc/auth/faculty_auth_cubit.dart';
import '../../../blocs/faculty_bloc/auth/faculty_auth_states.dart';


class AddUniversityDialog extends StatelessWidget {
  final int facultyId;
  final TextEditingController universityNameController = TextEditingController();
  final TextEditingController collegeController = TextEditingController();
  final TextEditingController majorController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  AddUniversityDialog({super.key, required this.facultyId});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('إضافة جامعة'),
      content: BlocConsumer<FacultyAuthCubit, FacultyAuthState>(
        listener: (context, state) {
          if (state is AuthAddFacultyStudyInfo) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('تم إضافة معلومات الدراسة بنجاح')),
              
            );
            // Navigator.of(context).pop(); // إغلاق الحوار بعد النجاح
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('حدث خطأ: ${state.error}')),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return Center(child: CircularProgressIndicator());
          }
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

              authCubit.addFacultyStudyInfo(
                facultyId
                ,{
                'university_name': universityName,
                'college': college,
                'major': major,
              });
              Navigator.of(context).pop();
            }
          },
          child: Text('إضافة'),
        ),
      ],
    );
  }
}
