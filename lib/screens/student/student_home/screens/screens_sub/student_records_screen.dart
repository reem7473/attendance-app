import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/student_bloc/navbar/student_cubit.dart';
import '../../../../../blocs/student_bloc/navbar/student_states.dart';

class StudentRecordsScreenSub extends StatelessWidget {
  final int studentId;

  StudentRecordsScreenSub({super.key, required this.studentId});

  Future<bool> _onWillPop(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('تأكيد الخروج'),
            content: Text('هل تريد الخروج فعلاً؟'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('لا'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('نعم'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AppStudentCubit(studentStudyInfoId: studentId, studentId: studentId)
            ..fetchStudentAttendanceData(studentId),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'السجلات',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<AppStudentCubit, AppStudentStates>(
          builder: (context, state) {
            if (state is StudentAttendanceLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is StudentAttendanceLoaded) {
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: state.studentAttendance.length,
                itemBuilder: (context, index) {
                  final studentAttendance = state.studentAttendance[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 8,
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      title: Text(
                        '${studentAttendance['course_name']}',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'التاريخ: ${studentAttendance['attendance_date']}'),
                            Text('اليوم: ${studentAttendance['day_of_week']}'),
                            Text(
                                'الوقت: ${studentAttendance['attendance_time']}'),
                          ],
                        ),
                      ),
                      trailing: Icon(
                        studentAttendance['attendance_status'] == 'present'
                            ? Icons.check
                            : Icons.close,
                        color:
                            studentAttendance['attendance_status'] == 'present'
                                ? Colors.green
                                : Colors.red,
                        size: 30.0,
                      ),
                    ),
                  );
                },
              );
            } else if (state is StudentAttendanceError) {
              return Center(child: Text('حدث خطأ: ${state.message}'));
            } else {
              return Center(child: Text('لا توجد بيانات'));
            }
          },
        ),
      ),
    );
  }
}
