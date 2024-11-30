import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // إضافة المكتبة
import '../../../../../blocs/student_bloc/auth/student_auth_cubit.dart';
import '../../../../../blocs/student_bloc/auth/student_auth_states.dart';
import '../../../../../services/api_service.dart';

class StudentCoursesScreenSub extends StatefulWidget {
  final int studentStudyInfoId;

  StudentCoursesScreenSub({required this.studentStudyInfoId});

  @override
  _StudentCoursesScreenSubState createState() =>
      _StudentCoursesScreenSubState();
}

class _StudentCoursesScreenSubState extends State<StudentCoursesScreenSub> {
  late Connectivity _connectivity;

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _checkInternetConnection();
  }

  Future<void> _checkInternetConnection() async {
    var result = await _connectivity.checkConnectivity();
    if (result == ConnectivityResult.none) {
      _showNoInternetDialog();
    } else {
      context.read<StudentAuthCubit>().getStudentCourses(widget.studentStudyInfoId);
    }
  }

  void _showNoInternetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('لا يوجد اتصال بالإنترنت'),
          content: Text('يرجى التحقق من اتصالك بالإنترنت وإعادة المحاولة.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('موافق'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentAuthCubit(ApiService())..getStudentCourses(widget.studentStudyInfoId),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'المقررات',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<StudentAuthCubit, StudentAuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is StudentCoursesLoaded) {
              final courses = state.courses;
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  final presentCount = course['present_count'];
                  final absentCount = course['absent_count'];
                  final totalCount = presentCount + absentCount;
                  final attendancePercentage =
                      totalCount > 0 ? presentCount / totalCount : 0.0;

                  Color getColorForPercentage(double percentage) {
                    return Color.lerp(Colors.red, Colors.green, percentage)!;
                  }

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
                        course['course_name'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: CircularPercentIndicator(
                          radius: 60.0,
                          lineWidth: 5.0,
                          percent: attendancePercentage,
                          center: Text(
                            "${(attendancePercentage * 100).toStringAsFixed(1)}%",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          progressColor:
                              getColorForPercentage(attendancePercentage),
                        ),
                      ),
                      trailing: IconButton(
                        iconSize: 30.0,
                        color: Color.fromARGB(255, 29, 72, 166),
                        icon: Icon(Icons.remove_red_eye),
                        onPressed: () {
                          _showAttendanceDialog(context, course['course_name'],
                              presentCount, absentCount);
                        },
                      ),
                    ),
                  );
                },
              );
            } else if (state is AuthError) {
              return Center(child: Text('حدث خطأ: ${state.error}'));
            } else {
              return Container();
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AddCourseDialog(
                    studentStudyInfoId: widget.studentStudyInfoId);
              },
            ).then((_) {
              _checkInternetConnection();
            });
          },
          child: Icon(Icons.add),
          backgroundColor: Color(0xFF1d48a6),
        ),
      ),
    );
  }

  void _showAttendanceDialog(BuildContext context, String courseName,
      int presentCount, int absentCount) {
    final totalDays = presentCount + absentCount;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('سجلات الحضور والغياب'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('المقرر: $courseName'),
              Text('عدد أيام الحضور: $presentCount'),
              Text('عدد أيام الغياب: $absentCount'),
              Text('مجموع الأيام: $totalDays'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('إغلاق'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}


class AddCourseDialog extends StatefulWidget {
  final int studentStudyInfoId;

  AddCourseDialog({required this.studentStudyInfoId});

  @override
  _AddCourseDialogState createState() => _AddCourseDialogState();
}

class _AddCourseDialogState extends State<AddCourseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _courseNameController = TextEditingController();
  final _levelController = TextEditingController();
  final _divisionController = TextEditingController();
  late Connectivity _connectivity;

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
  }

  @override
  void dispose() {
    _courseNameController.dispose();
    _levelController.dispose();
    _divisionController.dispose();
    super.dispose();
  }

  Future<void> _checkInternetAndSaveCourse() async {
    var result = await _connectivity.checkConnectivity();
    if (result == ConnectivityResult.none) {
      _showNoInternetDialog();
    } else {
      _saveCourse();
    }
  }

  void _saveCourse() {
    if (_formKey.currentState!.validate()) {
      final courseName = _courseNameController.text;
      final level = _levelController.text;
      final division = _divisionController.text;

      context.read<StudentAuthCubit>().saveStudentCourse(
        widget.studentStudyInfoId,
        {
          'course_name': courseName,
          'level': level,
          'division': division,
        },
      );
    }
  }

  void _showNoInternetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('لا يوجد اتصال بالإنترنت'),
          content: Text('يرجى التحقق من اتصالك بالإنترنت وإعادة المحاولة.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('موافق'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentAuthCubit, StudentAuthState>(
      listener: (context, state) {
        if (state is CourseSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.of(context).pop();
          context.read<StudentAuthCubit>().getStudentCourses(widget.studentStudyInfoId);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('فشل في إضافة المقرر: ${state.error}'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      builder: (context, state) {
        return AlertDialog(
          title: Text('إضافة مقرر جديد'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _courseNameController,
                  decoration: InputDecoration(labelText: 'اسم المقرر'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال اسم المقرر';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  controller: _levelController,
                  decoration: InputDecoration(labelText: 'المستوى'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال المستوى';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  controller: _divisionController,
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
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _checkInternetAndSaveCourse();
              },
              child: Text('إضافة'),
            ),
          ],
        );
      },
    );
  }
}
