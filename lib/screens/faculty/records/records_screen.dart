import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import '../../../services/records.dart';
import '../attendance/course_attendance_record_screen.dart';

class RecordsScreen extends StatelessWidget {
  final int faculty_id;

  RecordsScreen({super.key, required this.faculty_id});

  
  Future<bool> _onWillPop(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('تأكيد تسجيل الخروج'),
            content: Text('هل أنت متأكد أنك تريد تسجيل الخروج؟'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Text('تأكيد'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecordsCubit()..fetchAttendanceRecords(faculty_id),
      child: WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Scaffold(
          appBar: AppBar(
            title: const Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                  child: Text(
                    'السجلات',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            automaticallyImplyLeading: false,
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 255, 255, 255), Color.fromARGB(255, 255, 255, 255)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: BlocBuilder<RecordsCubit, RecordsState>(
              builder: (context, state) {
                if (state is RecordsLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is RecordsLoaded) {
                  if (state.records.isEmpty) {
                    return Center(child: Text('لا توجد سجلات'));
                  } else {
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.all(16),
                      itemCount: state.records.length,
                      itemBuilder: (context, index) {
                        final record = state.records[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                // colors: [
                                //   Color.fromARGB(255, 29, 72, 166),
                                //   Color.fromARGB(255, 238, 240, 241),
                                // ],
                                colors: [
                                  Color.fromARGB(255, 255, 255, 255),
                                  Color.fromARGB(255, 255, 255, 255),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
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
                              contentPadding: EdgeInsets.zero,
                              // leading: Icon(Icons.school, color: Colors.blueAccent, size: 30),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.school, size: 20, color: Color.fromARGB(255, 29, 72, 166),),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          '${record['university_name']}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.home, size: 20, color: Color.fromARGB(255, 29, 72, 166),),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          '${record['college']} - ${record['major']}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.book, size: 20, color: Color.fromARGB(255, 29, 72, 166),),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          '${record['course_name']}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.date_range, size: 20, color: Color.fromARGB(255, 29, 72, 166),),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'التاريخ: ${record['attendance_date']}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_today, size: 20, color: Color.fromARGB(255, 29, 72, 166),),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'اليوم: ${record['day_of_week']}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: PopupMenuButton<String>(
                                icon: Icon(Icons.more_vert, color: const Color.fromARGB(255, 29, 72, 166),),
                                onSelected: (String result) {
                                  if (result == 'preview') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CourseAttendanceRecordScreen(
                                          attendanceRecordId: record['id'],
                                          attendance: '${record['attendance_date']}',
                                        ),
                                      ),
                                    );
                                  }
                                },
                                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                   const PopupMenuItem<String>(
                                    value: 'preview',
                                    child: Row(
                                      children: [
                                        Icon(Icons.visibility, color: Colors.black),
                                        SizedBox(width: 8),
                                        Text('معاينة', style: TextStyle(color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                  // const PopupMenuItem<String>(
                                  //   value: 'share',
                                  //   child: Text('مشاركة'),
                                  // ),
                                  // const PopupMenuItem<String>(
                                  //   value: 'export',
                                  //   child: Text('تصدير الى ملف PDF'),
                                  // ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CourseAttendanceRecordScreen(
                                      attendanceRecordId: record['id'],
                                      attendance: '${record['attendance_date']}',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }
                } else if (state is RecordsError) {
                  return Center(child: Text(state.message));
                } else {
                  return Center(child: Text('لا توجد بيانات'));
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _exportToPdf(BuildContext context, Map<String, dynamic> record) async {
    try {
      if (await Permission.storage.request().isGranted) {
        final pdf = pw.Document();
        pdf.addPage(
          pw.Page(
            build: (pw.Context context) => pw.Center(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('تفاصيل السجل', style: pw.TextStyle(fontSize: 24)),
                  pw.SizedBox(height: 20),
                  pw.Text('اسم الجامعة: ${record['university_name']}'),
                  pw.Text('اسم الكلية: ${record['college']}'),
                  pw.Text('التخصص: ${record['major']}'),
                  pw.Text('اسم المقرر: ${record['course_name']}'),
                  pw.Text('التاريخ: ${record['attendance_date']}'),
                  pw.Text('اليوم: ${record['day_of_week']}'),
                ],
              ),
            ),
          ),
        );

        final output = await getExternalStorageDirectory();
        final file = File("${output!.path}/record_${record['id']}.pdf");
        await file.writeAsBytes(await pdf.save());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم تصدير السجل إلى ملف PDF: ${file.path}')),
        );
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
