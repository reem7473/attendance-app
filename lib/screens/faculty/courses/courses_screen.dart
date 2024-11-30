import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/faculty_bloc/auth/faculty_auth_cubit.dart';
import '../../../blocs/faculty_bloc/auth/faculty_auth_states.dart';
import '../../../services/api_service.dart';
import '../attendance/preparation_time/preparation_time_screen.dart';
import 'add_course_dialog.dart';

class CoursesScreen extends StatefulWidget {
  final int facultyId;

  const CoursesScreen({super.key, required this.facultyId});

  @override
  _CoursesScreenState createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  late FacultyAuthCubit _authCubit;
  final ScrollController _scrollController = ScrollController();
  bool _isFabVisible = true;

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
  void initState() {
    super.initState();
    _authCubit = FacultyAuthCubit(ApiService())
      ..fetchAllFacultyStudyInfoCourses(widget.facultyId);

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isFabVisible) {
          setState(() {
            _isFabVisible = false;
          });
        }
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _authCubit,
      child: WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Scaffold(
          appBar: AppBar(
            title: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 24.0),
                  child: const Text(
                    'المقررات',
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
            child: BlocBuilder<FacultyAuthCubit, FacultyAuthState>(
              builder: (context, state) {
                if (state is AuthLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is AllFacultyStudyInfoCoursesLoaded) {
                  if (state.data.isEmpty) {
                    return Center(
                        child: Text(
                            'لا توجد مقررات يمكن اضافة المقررات من خلال الضغط على الزر +'));
                  } else {
                    final data = state.data;
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      controller: _scrollController,
                      padding: EdgeInsets.all(16.0),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final facultyStudyInfo = data[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 8,
                          child: ExpansionTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  facultyStudyInfo['university_name'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  facultyStudyInfo['college'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  facultyStudyInfo['major'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            children: facultyStudyInfo['courses']
                                .map<Widget>((course) {
                              return CourseCard(
                                id: course['course_id'],
                                universityName:
                                    facultyStudyInfo['university_name'],
                                collegeName: facultyStudyInfo['college'],
                                specialization: facultyStudyInfo['major'],
                                courseName: course['course_name'],
                                level: course['level'],
                                section: course['section'],
                                onViewAttendancePressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PreparationTimeScreen(
                                              courseId: course['course_id']),
                                    ),
                                  );
                                },
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PreparationTimeScreen(
                                              courseId: course['course_id']),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                        );
                      },
                    );
                  }
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
                      builder: (context) =>
                          AddCourseDialog(facultyId: widget.facultyId),
                    );
                  },
                  child: Icon(Icons.add),
                  backgroundColor: Color.fromARGB(255, 29, 72, 166),
                )
              : null,
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String universityName;
  final String collegeName;
  final String specialization;
  final String courseName;
  final String level;
  final String section;
  final VoidCallback onPressed;
  final VoidCallback onViewAttendancePressed;
  final int id;

  CourseCard({
    required this.universityName,
    required this.collegeName,
    required this.specialization,
    required this.courseName,
    required this.level,
    required this.section,
    required this.onViewAttendancePressed,
    required this.onPressed,
    required this.id,
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
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 29, 72, 166),
              Color.fromARGB(255, 238, 240, 241),
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
                'المقرر : $courseName',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                'المستوى : $level',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              Text(
                'الشعبة : $section',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                  height:
                      8.0), // Space between university details and course details
              // Text(
              //   '$courseName - $level - $section',
              //   style: TextStyle(
              //     fontSize: 14,
              //     color: Colors.white70,
              //   ),
              // ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.pageview,
              color: Color.fromARGB(255, 239, 240, 243),
            ),
            onPressed: onViewAttendancePressed,
          ),
          onTap: onPressed,
        ),
      ),
    );
  }
}
