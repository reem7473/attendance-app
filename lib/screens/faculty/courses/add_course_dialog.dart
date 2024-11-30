import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/faculty_bloc/auth/faculty_auth_cubit.dart';
import '../../../blocs/faculty_bloc/auth/faculty_auth_states.dart';

class AddCourseDialog extends StatelessWidget {

  final int facultyId;
  final TextEditingController universityNameController = TextEditingController();
  final TextEditingController collegeController = TextEditingController();
  final TextEditingController specializationController = TextEditingController();
  final TextEditingController courseNameController = TextEditingController();
  final TextEditingController levelController = TextEditingController();
  final TextEditingController sectionController = TextEditingController();

  AddCourseDialog({super.key, required this.facultyId});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('إضافة مقرر'),
      content: BlocConsumer<FacultyAuthCubit, FacultyAuthState>(
        listener: (context, state) {
          if (state is AuthAddFacultyStudyInfoAndCourses) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تمت إضافة المقرر بنجاح')),
            );
            Navigator.of(context).pop();
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('حدث خطأ: ${state.error}')),
            );
          }
        },
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: universityNameController,
                decoration: InputDecoration(labelText: 'اسم الجامعة'),
              ),
              TextField(
                controller: collegeController,
                decoration: InputDecoration(labelText: 'الكلية'),
              ),
              TextField(
                controller: specializationController,
                decoration: InputDecoration(labelText: 'التخصص'),
              ),
              TextField(
                controller: courseNameController,
                decoration: InputDecoration(labelText: 'اسم المقرر'),
              ),
              TextField(
                controller: levelController,
                decoration: InputDecoration(labelText: 'المستوى'),
              ),
              TextField(
                controller: sectionController,
                decoration: InputDecoration(labelText: 'الشعبة'),
              ),
            ],
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
        BlocBuilder<FacultyAuthCubit, FacultyAuthState>(
          builder: (context, state) {
            return ElevatedButton(
              onPressed: () {
                if (state is! AuthLoading) {
                  final data = {
                    'university_name': universityNameController.text,
                    'college': collegeController.text,
                    'major': specializationController.text,
                    'course_name': courseNameController.text,
                    'level': levelController.text,
                    'section': sectionController.text,
                  };

                  final authCubit = context.read<FacultyAuthCubit>();
                  authCubit.addFacultyStudyInfoCourse(facultyId,data);
                }
              },
              child: state is AuthLoading
                  ? CircularProgressIndicator()
                  : Text('إضافة'),
            );
          },
        ),
      ],
    );
  }
}
