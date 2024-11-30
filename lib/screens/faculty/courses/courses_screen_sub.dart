import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/faculty_bloc/auth/faculty_auth_cubit.dart';
import '../../../blocs/faculty_bloc/auth/faculty_auth_states.dart';
import '../../../services/api_service.dart';

import '../attendance/preparation_time/preparation_time_screen.dart';
import 'add_course_dialog_sub.dart';
import 'edit_course_dialog_sub.dart';

class CoursesScreenSub extends StatefulWidget {
  final int facultyStudyInfoId;

  CoursesScreenSub({required this.facultyStudyInfoId});

  @override
  _CoursesScreenSubState createState() => _CoursesScreenSubState();
}

class _CoursesScreenSubState extends State<CoursesScreenSub> {
  late FacultyAuthCubit _authCubit;
  final ScrollController _scrollController = ScrollController();
  bool _isFabVisible = true;

  @override
  void initState() {
    super.initState();
    _authCubit = FacultyAuthCubit(ApiService());
    _authCubit.getCoursesByFaculty(widget.facultyStudyInfoId);

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (_isFabVisible) {
          setState(() {
            _isFabVisible = false;
          });
        }
      } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
        if (!_isFabVisible) {
          setState(() {
            _isFabVisible = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _refreshCourses() {
    _authCubit.getCoursesByFaculty(widget.facultyStudyInfoId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _authCubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'المقررات',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: Container(
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
              if (state is AuthLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is AuthGetCoursesFacultySuccess) {
                final courses = state.dataCourse;
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  controller: _scrollController,
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final Map<String, dynamic> course = courses[index];
                    return CourseCardSub(
                      courseId: course['course_id'],
                      courseName: course['course_name'],
                      level: course['level'],
                      section: course['section'],
                      onDeletePressed: () {
                        context.read<FacultyAuthCubit>().deleteCourse(widget.facultyStudyInfoId, course['course_id']);
                        _refreshCourses();
                      },
                      onEditPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => EditCourseDialogSub(
                            facultyStudyInfoId: widget.facultyStudyInfoId,
                            courseId: course['course_id'],
                            courseName: course['course_name'],
                            level: course['level'],
                            section: course['section'],
                          ),
                        ).then((_) {
                          _refreshCourses();
                        });
                      },
                      onViewAttendancePressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PreparationTimeScreen(courseId: course['course_id']),
                          ),
                        );
                      },
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PreparationTimeScreen(courseId: course['course_id']),
                          ),
                        );
                      },
                    );
                  },
                );
              } else if (state is AuthGetCoursesFacultyEmpty) {
                return Center(child: Text(state.message));
              } else if (state is AuthError) {
                return Center(child: Text('حدث خطأ: ${state.error}'));
              } else {
                return Container();
              }
            },
          ),
        ),
        floatingActionButton: _isFabVisible
            ? FloatingActionButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AddCourseDialogSub(
                      facultyStudyInfoId: widget.facultyStudyInfoId,
                    ),
                  ).then((_) {
                    _refreshCourses();
                  });
                },
                child: Icon(Icons.add),
              )
            : null,
      ),
    );
  }
}

class CourseCardSub extends StatelessWidget {
  final int courseId;
  final String courseName;
  final String level;
  final String section;
  final VoidCallback onDeletePressed;
  final VoidCallback onEditPressed;
  final VoidCallback onViewAttendancePressed;
  final VoidCallback onPressed;

  CourseCardSub({
    required this.courseId,
    required this.courseName,
    required this.level,
    required this.section,
    required this.onDeletePressed,
    required this.onEditPressed,
    required this.onViewAttendancePressed,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
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
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'اسم المقرر: $courseName',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                'المستوى: $level',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                'القسم: $section',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: onDeletePressed,
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Color.fromARGB(255, 29, 72, 166)),
                onPressed: onEditPressed,
              ),
              IconButton(
                icon: Icon(Icons.pageview, color: const Color.fromARGB(255, 29, 72, 166)),
                onPressed: onViewAttendancePressed,
              ),
            ],
          ),
          onTap: onPressed,
        ),
      ),
    );
  }
}
