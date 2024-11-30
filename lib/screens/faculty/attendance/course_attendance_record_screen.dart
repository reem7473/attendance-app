import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import '../../../services/api_service.dart';
import '../../../services/student_attendance_cubit.dart';
import '../../../services/student_attendance_state.dart';

class CourseAttendanceRecordScreen extends StatelessWidget {
  final int attendanceRecordId;
  final String attendance;

  CourseAttendanceRecordScreen({super.key, required this.attendanceRecordId, required this.attendance});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentAttendanceCubit(ApiService())..createAndFetchStudentAttendance(attendanceRecordId),
      child: Scaffold(
        
        body: BlocBuilder<StudentAttendanceCubit, StudentAttendanceState>(
          builder: (context, state) {
            if (state is StudentAttendanceLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is StudentAttendanceLoaded) {
              if (state.studentAttendance.isEmpty) {
                return Center(child: Text('لا يوجد طلاب في هذا المقرر', style: TextStyle(color: Colors.black)));
              }
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: state.studentAttendance.length,
                  itemBuilder: (context, index) {
                    final student = state.studentAttendance[index];
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16.0),
                          leading: CircleAvatar(
                            child: Text('${index + 1}'),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${student['student_name']}',
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                student['student_number'],
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                student['attendance_time'] ?? 'الوقت الذي تم تحضير نفسه فيه',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                          trailing: Icon(
                            student['attendance_status'] == 'present' ? Icons.check : Icons.close,
                            color: student['attendance_status'] == 'present' ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (state is StudentAttendanceError) {
              return Center(child: Text('لا يوجد طلاب في هذا المقرر', style: TextStyle(color: Colors.black)));
            } else {
              return Center(child: Text('No data available', style: TextStyle(color: Colors.black)));
            }
          },
        ),
      ),
    );
  }

  static Future<void> exportToPdf(BuildContext context, int attendanceRecordId) async {
    try {
      if (await Permission.storage.request().isGranted) {
        final pdf = pw.Document();
        final cubit = context.read<StudentAttendanceCubit>();
        final state = cubit.state;

        if (state is StudentAttendanceLoaded && state.studentAttendance.isNotEmpty) {
          final studentAttendance = state.studentAttendance;

          pdf.addPage(
            pw.Page(
              build: (pw.Context context) => pw.Center(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('سجل الحضور', style: pw.TextStyle(fontSize: 24)),
                    pw.SizedBox(height: 20),
                    ...studentAttendance.map((student) => pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('${student['student_name']} - ${student['student_number']}'),
                        pw.Text('${student['attendance_time'] ?? 'الوقت الذي تم تحضير نفسه فيه'}'),
                      ],
                    )),
                  ],
                ),
              ),
            ),
          );

          final output = await getExternalStorageDirectory();
          final file = File("${output!.path}/attendance_record_$attendanceRecordId.pdf");
          await file.writeAsBytes(await pdf.save());

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم تصدير السجل إلى ملف PDF: ${file.path}')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('لا توجد بيانات لتصديرها')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('لم يتم منح الصلاحيات اللازمة للوصول إلى التخزين')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء التصدير إلى PDF: ${e.toString()}')),
      );
    }
  }
}
