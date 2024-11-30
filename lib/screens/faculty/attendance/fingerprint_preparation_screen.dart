import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/records.dart';
import 'attendance_records_tab.dart';

class FingerprintPreparationScreen extends StatelessWidget {
  final int faculty_id;

  FingerprintPreparationScreen({super.key, required this.faculty_id});

  
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
      create: (context) => RecordsCubit()..fetchFingerprintPreparation(faculty_id),
      child: WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Scaffold(
          appBar:AppBar(
            title: const Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                  child: Text(
                    'التحضير من خلال البصمة',
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
                colors: [
                  Color.fromARGB(255, 255, 255, 255),
                  Color.fromARGB(255, 255, 255, 255)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: BlocBuilder<RecordsCubit, RecordsState>(
              builder: (context, state) {
                if (state is FingerprintLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is FingerprintLoaded) {
                  if (state.fingerprint.isEmpty) {
                    return Center(child: Text('لا توجد بيانات للتحضير يرجى ادخال البيانات من القائمة الرئيسية'));
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: state.fingerprint.length,
                        itemBuilder: (context, index) {
                          final record = state.fingerprint[index];
                          return FingerprintCourseCard(
                            universityName: '${record['university_name']}',
                            specialization: '${record['major']}',
                            courseName: '${record['course_name']}',
                            level: '${record['level']}',
                            section: '${record['section']}',
                            startDate: '${record['start_date']}',
                            endDate: '${record['end_date']}',
                            onCardPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AttendanceRecordsTab(preparationTimesId: record['id']),
                                ),
                              );
                            },
                            onViewAttendancePressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AttendanceRecordsTab(preparationTimesId: record['id']),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  }
                } else if (state is FingerprintError) {
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
}


class FingerprintCourseCard extends StatelessWidget {
  final String universityName;
  final String specialization;
  final String level;
  final String courseName;
  final String section;
  final String startDate;
  final String endDate;
  final VoidCallback onViewAttendancePressed;
  final VoidCallback onCardPressed;

  FingerprintCourseCard({
    required this.universityName,
    required this.specialization,
    required this.level,
    required this.courseName,
    required this.section,
    required this.startDate,
    required this.endDate,
    required this.onViewAttendancePressed,
    required this.onCardPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        
      ),
      elevation:8,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(16.0),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'الجامعة: $universityName',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                'التخصص: $specialization',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                'اسم المقرر: $courseName',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                'المستوى: $level',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                'القسم: $section',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.0), // Space between university details and course details
              Text(
                'تاريخ البدء: $startDate',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              Text(
                'تاريخ الانتهاء: $endDate',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.pageview, color: Color.fromARGB(255, 29, 72, 166),),
            onPressed: onViewAttendancePressed,
          ),
          onTap: onCardPressed,
        ),
      ),
    );
  }
}

class EditFingerprintCourseDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('تعديل بيانات المقرر'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Add dropdowns for university, specialization, etc.
          TextField(
            decoration: InputDecoration(labelText: 'اسم الجامعة'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'التخصص'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'اسم المقرر'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'المستوى'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'الشعبة'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'الوقت المخصص للتحضير'),
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
            // Save edited course data
            Navigator.of(context).pop();
          },
          child: Text('حفظ'),
        ),
      ],
    );
  }
}

class AddFingerprintCourseDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('إضافة مقرر'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Add dropdowns for university, specialization, etc.
          TextField(
            decoration: InputDecoration(labelText: 'اسم الجامعة'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'التخصص'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'اسم المقرر'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'المستوى'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'الشعبة'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'الوقت المخصص للتحضير'),
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
            Navigator.of(context).pop();
          },
          child: Text('إضافة'),
        ),
      ],
    );
  }
}
