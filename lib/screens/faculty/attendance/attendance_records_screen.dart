import 'package:flutter/material.dart';
import 'course_attendance_record_screen.dart';
import 'fingerprint_authentication/fingerprint_authentication_screen.dart';

class AttendanceRecordsScreen extends StatelessWidget {
  final int preparationTimeId;
  final int attendanceRecordId;
  final String attendance;

  const AttendanceRecordsScreen({
    Key? key,
    required this.preparationTimeId,
    required this.attendanceRecordId,
    required this.attendance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'سجل حضور ($attendance)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.picture_as_pdf),
              onPressed: () async {
                // await CourseAttendanceRecordScreen.exportToPdf(context, attendanceRecordId);
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: Container(
              color: Colors.white,
              child: TabBar(
                indicator: BoxDecoration(
                  color: Color.fromARGB(255, 29, 72, 166),
                  borderRadius: BorderRadius.circular(8),
                ),
                tabs: [
                  Tab(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('سجلات',
                      style: TextStyle(
                  fontSize: 16,
                ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('البصمة',
                      style: TextStyle(
                  fontSize: 16,
                ),
                      ),
                    ),
                  ),
                ],
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.label,
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            CourseAttendanceRecordScreen(attendanceRecordId: attendanceRecordId, attendance: attendance),
            FingerprintAuthenticationScreen(attendanceRecordId: attendanceRecordId),
          ],
        ),
      ),
    );
  }
}
