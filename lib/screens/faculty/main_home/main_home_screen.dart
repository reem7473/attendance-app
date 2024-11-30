import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/faculty_bloc/auth/faculty_auth_cubit.dart';
import '../../../blocs/faculty_bloc/auth/faculty_auth_states.dart';
import '../../../services/api_service.dart';
import '../courses/courses_screen_sub.dart';
import 'add_faculty_study_dialog.dart';
import 'edit_faculty_study_dialog.dart';

class MainHomeScreen extends StatefulWidget {
  final int facultyId;

  const MainHomeScreen({Key? key, required this.facultyId}) : super(key: key);

  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
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
    _authCubit = FacultyAuthCubit(ApiService());
    _authCubit.fetchFacultyStudyInfo(widget.facultyId);

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

  void _refreshData() {
    _authCubit.fetchFacultyStudyInfo(widget.facultyId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _authCubit,
      child: WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Scaffold(
          appBar: AppBar(
            title: const Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                  child: Text(
                    'الرئيسية',
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
                } else if (state is StudyInfoLoaded) {
                  if (state.studyInfo.isEmpty) {
                    return Center(
                      child: Text(
                        'لا توجد بيانات يمكن اضافة المعلومات من خلال الضغط على الزر +',
                      ),
                    );
                  } else {
                    return ListView.builder(
                      controller: _scrollController,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.all(16),
                      itemCount: state.studyInfo.length,
                      itemBuilder: (context, index) {
                        final info = state.studyInfo[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: UniversityCard(
                            id: info['id'],
                            universityName: info['university_name'],
                            collegeName: info['college'],
                            specialization: info['major'],
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CoursesScreenSub(
                                    facultyStudyInfoId: info['id'],
                                  ),
                                ),
                              );
                            },
                            onEditPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => EditUniversityDialog(
                                  id: info['id'],
                                  universityName: info['university_name'],
                                  collegeName: info['college'],
                                  specialization: info['major'],
                                ),
                              ).then((_) {
                                _refreshData();
                              });
                            },
                            onDeletePressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  title: Text('تأكيد الحذف'),
                                  content: Text(
                                      'هل أنت متأكد أنك تريد حذف هذا العنصر؟'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close dialog
                                      },
                                      child: Text('إلغاء'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context
                                            .read<FacultyAuthCubit>()
                                            .deleteFacultyStudyInfo(info['id']);
                                        Navigator.of(context)
                                            .pop(); // Close dialog
                                        _refreshData();
                                      },
                                      child: Text('حذف'),
                                    ),
                                  ],
                                ),
                              ).then((_) {
                                _refreshData();
                              });
                            },
                          ),
                        );
                      },
                    );
                  }
                } else if (state is StudyInfoEmpty) {
                  return Center(child: Text(state.message));
                } else if (state is AuthStudyInfoError) {
                  return Center(
                    child: 
                    // const Text(
                    //   'لا توجد بيانات يمكن اضافة المعلومات من خلال الضغط على الزر +',
                    // ),
                    Text(state.error),
                  );
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
                          AddUniversityDialog(facultyId: widget.facultyId),
                    ).then((_) {
                      _refreshData();
                    });
                  },
                  child: Icon(Icons.add),
                  tooltip: 'إضافة جامعة',
                )
              : null,
        ),
      ),
    );
  }
}
class UniversityCard extends StatelessWidget {
  final int id;
  final String universityName;
  final String collegeName;
  final String specialization;
  final VoidCallback onPressed;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed; 

  UniversityCard({
    required this.id,
    required this.universityName,
    required this.collegeName,
    required this.specialization,
    required this.onPressed,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.all(16.0),
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
            contentPadding: EdgeInsets.zero,
            title: Text(
              'الجامعة: $universityName',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black, 
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الكلية: $collegeName',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87, 
                  ),
                ),
                Text(
                  'التخصص: $specialization',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87, 
                  ),
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: Colors.black),
              onSelected: (String value) {
                if (value == 'edit') {
                  onEditPressed();
                } else if (value == 'delete') {
                  onDeletePressed();
                } else if (value == 'courses') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CoursesScreenSub(facultyStudyInfoId: id),
                    ),
                  );
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'courses',
                  child: ListTile(
                    leading: Icon(Icons.book, color: Color.fromARGB(255, 29, 72, 166)),
                    title: Text('معاينة المقررات'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit, color: Color.fromARGB(255, 29, 72, 166)),
                    title: Text('تعديل'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text('حذف'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
