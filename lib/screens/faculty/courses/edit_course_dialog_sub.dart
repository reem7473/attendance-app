import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/faculty_bloc/auth/faculty_auth_cubit.dart';

class EditCourseDialogSub extends StatelessWidget {
  final int facultyStudyInfoId;
  final int courseId;
  final TextEditingController courseNameController;
  final TextEditingController levelController;
  final TextEditingController sectionController;

  EditCourseDialogSub({
    required this.facultyStudyInfoId,
    required this.courseId,
    required String courseName,
    required String level,
    required String section,
  })  : courseNameController = TextEditingController(text: courseName),
        levelController = TextEditingController(text: level),
        sectionController = TextEditingController(text: section);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('تعديل مقرر'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
            final courseName = courseNameController.text;
            final level = levelController.text;
            final section = sectionController.text;

            final authCubit = context.read<FacultyAuthCubit>();
            authCubit.updateCourse(facultyStudyInfoId, courseId, {
              'course_name': courseName,
              'level': level,
              'section': section,
            });

            Navigator.of(context).pop();
          },
          child: Text('حفظ التعديل'),
        ),
      ],
    );
  }
}
