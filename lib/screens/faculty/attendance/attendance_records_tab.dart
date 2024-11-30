import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/faculty_bloc/auth/faculty_auth_cubit.dart';
import '../../../blocs/faculty_bloc/auth/faculty_auth_states.dart';
import '../../../services/api_service.dart';
import 'attendance_records_screen.dart';
import 'preparation_time/edit_preparation_time_dialog.dart';

class AttendanceRecordsTab extends StatelessWidget {
  final int preparationTimesId;

  AttendanceRecordsTab({required this.preparationTimesId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FacultyAuthCubit(ApiService())..fetchAttendanceRecords(preparationTimesId),
      child: Scaffold(
          appBar: AppBar(
          title: Text(
            'سجلات الحضور والغياب',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => EditPreparationTimeDialog(preparationTimeId: preparationTimesId),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 255, 255, 255),
                  Color.fromARGB(255, 255, 255, 255)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: BlocBuilder<FacultyAuthCubit, FacultyAuthState>(
              builder: (context, state) {
                if (state is AttendanceRecordsLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is AttendanceRecordsLoaded) {
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: state.records.length,
                    itemBuilder: (context, index) {
                      final record = state.records[index];
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
                            leading: CircleAvatar(
                              child: Text('${index + 1}', style: TextStyle(color: Colors.black)),
                              backgroundColor: Colors.white,
                            ),
                            title: Text(
                              'سجل حضور (${record['attendance_date']})',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              '${record['day_of_week']} – ${record['time']}',
                              style: TextStyle(color: Colors.black),
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) async {
                                switch (value) {
                                  case 'preview':
                                     Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AttendanceRecordsScreen(attendanceRecordId: record['id'], attendance: '${record['attendance_date']}', preparationTimeId: preparationTimesId,),
                                ),
                              );
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'preview',
                                  child: Row(
                                    children: [
                                      Icon(Icons.visibility, color: Colors.black),
                                      SizedBox(width: 8),
                                      Text('معاينة', style: TextStyle(color: Colors.black)),
                                    ],
                                  ),
                                ),
                                // PopupMenuItem(
                                //   value: 'share',
                                //   child: Row(
                                //     children: [
                                //       Icon(Icons.share, color: Colors.black),
                                //       SizedBox(width: 8),
                                //       Text('مشاركة', style: TextStyle(color: Colors.black)),
                                //     ],
                                //   ),
                                // ),
                                // PopupMenuItem(
                                //   value: 'export',
                                //   child: Row(
                                //     children: [
                                //       Icon(Icons.file_download, color: Colors.black),
                                //       SizedBox(width: 8),
                                //       Text('تصدير الى ملف PDF', style: TextStyle(color: Colors.black)),
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AttendanceRecordsScreen(attendanceRecordId: record['id'], attendance: '${record['attendance_date']}', preparationTimeId: preparationTimesId,),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is AttendanceRecordsError) {
                  return Center(child: Text('لا توجد سجلات حضور.', style: TextStyle(color: Colors.black)));
                } else {
                  return Center(child: Text('لا توجد سجلات حضور.', style: TextStyle(color: Colors.black)));
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
