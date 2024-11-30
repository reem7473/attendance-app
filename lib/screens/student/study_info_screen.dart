import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/student_bloc/auth/student_auth_cubit.dart';
import '../../blocs/student_bloc/auth/student_auth_states.dart';
import '../../services/api_service.dart';
import 'student_home/student_home_screen.dart';

class StudyInfoScreen extends StatefulWidget {
  final int studentId;

  const StudyInfoScreen({super.key, required this.studentId});
  @override
  _StudyInfoScreenState createState() => _StudyInfoScreenState();
}

class _StudyInfoScreenState extends State<StudyInfoScreen> {
  String? selectedUniversity;
  String? selectedCollege;
  String? selectedMajor;


  @override
  void initState() {
    super.initState();
    
    final authCubit = context.read<StudentAuthCubit>();
    authCubit.checkStudentStudyInfo(widget.studentId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StudentAuthCubit, StudentAuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          final studentStudyInfoId = state.user['id'];
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => StudentHomeScreen(
                studentStudyInfoId: studentStudyInfoId, studentId: widget.studentId,
              ),
            ),
          );
        }
      },
      child: BlocProvider(
        create: (context) => StudentAuthCubit(ApiService())..fetchAllFacultyStudyInfo(),
        child: Scaffold(
          appBar: AppBar(
            title: Text('معلومات الدراسة'),
          ),
          body: BlocBuilder<StudentAuthCubit, StudentAuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is StudyInfoLoaded) {
                final universities = state.studyInfo
                    .map((info) => info['university_name'])
                    .toSet()
                    .toList();
    
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DropdownButton<String>(
                        hint: Text('اختر الجامعة'),
                        value: selectedUniversity,
                        onChanged: (value) {
                          setState(() {
                            selectedUniversity = value;
                            selectedCollege = null;
                            selectedMajor = null;
                          });
                        },
                        items: universities.map((university) {
                          return DropdownMenuItem<String>(
                            value: university,
                            child: Text(university),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 16.0),
                      if (selectedUniversity != null)
                        DropdownButton<String>(
                          hint: Text('اختر الكلية'),
                          value: selectedCollege,
                          onChanged: (value) {
                            setState(() {
                              selectedCollege = value;
                              selectedMajor = null;
                            });
                          },
                          items: state.studyInfo
                              .where((info) =>
                                  info['university_name'] == selectedUniversity)
                              .map((info) => info['college'])
                              .toSet()
                              .map((college) {
                            return DropdownMenuItem<String>(
                              value: college,
                              child: Text(college),
                            );
                          }).toList(),
                        ),
                      SizedBox(height: 16.0),
                      if (selectedCollege != null)
                        DropdownButton<String>(
                          hint: Text('اختر التخصص'),
                          value: selectedMajor,
                          onChanged: (value) {
                            setState(() {
                              selectedMajor = value;
                            });
                          },
                          items: state.studyInfo
                              .where((info) =>
                                  info['university_name'] == selectedUniversity &&
                                  info['college'] == selectedCollege)
                              .map((info) => info['major'])
                              .toSet()
                              .map((major) {
                            return DropdownMenuItem<String>(
                              value: major,
                              child: Text(major),
                            );
                          }).toList(),
                        ),
                      SizedBox(height: 32.0),
                      ElevatedButton(
                        onPressed: () async {
                          if (selectedUniversity != null &&
                              selectedCollege != null &&
                              selectedMajor != null) {
                            final studyInfoId = state.studyInfo
                                .firstWhere(
                                  (info) =>
                                      info['university_name'] ==
                                          selectedUniversity &&
                                      info['college'] == selectedCollege &&
                                      info['major'] == selectedMajor,
                                  orElse: () => {},
                                )['id'];
    
                            await context.read<StudentAuthCubit>().saveStudentStudyInfo({
                              'student_id': widget.studentId, 
                              'university_name': selectedUniversity!,
                              'college': selectedCollege!,
                              'major': selectedMajor!,
                              'faculty_study_info_id': studyInfoId,
                            });
    
                            final newState = context.read<StudentAuthCubit>().state;
    
                            if (newState is AuthAuthenticated) {
                              final studentStudyInfoId = newState.user['id'];
    
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('تم حفظ معلومات الدراسة بنجاح'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
    
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StudentHomeScreen(
                                    studentStudyInfoId: studentStudyInfoId, studentId: widget.studentId,
                                  ),
                                ),
                              );
                            } else if (newState is AuthError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('فشل في حفظ معلومات الدراسة: ${newState.error}'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('يرجى اختيار جميع البيانات أولاً'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        child: Text('حفظ'),
                      ),
                    ],
                  ),
                );
              } else if (state is AuthError) {
                return Center(child: Text('حدث خطأ: ${state.error}'));
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
