import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../services/api_service.dart';
import '../../../../../shared/about_screen.dart';
import '../../../../../shared/terms_screen.dart';
import '../../../profile/bloc/profile_cubit.dart';
import '../../../profile/bloc/profile_state.dart';
import '../../../profile/student_edit_profile_screen.dart';


class StudentProfileScreenSub extends StatefulWidget {
  final int studentId;

  StudentProfileScreenSub({required this.studentId});

  @override
  _StudentProfileScreenSubState createState() => _StudentProfileScreenSubState();
}

class _StudentProfileScreenSubState extends State<StudentProfileScreenSub> {
  late ProfileStudentCubit _profileCubit;

  @override
  void initState() {
    super.initState();
    _profileCubit = ProfileStudentCubit(ApiService())..fetchProfile(widget.studentId);
  }

  @override
  void dispose() {
    _profileCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileStudentCubit>(
      create: (context) => _profileCubit,
      child: Scaffold(
        appBar: AppBar(
            title: Text(
              'الملف الشخصي',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        body: BlocConsumer<ProfileStudentCubit, ProfileStudentState>(
          listener: (context, state) {
            if (state is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              final profile = state.profile;
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: profile['profile_image_path'] != null
                                  ? NetworkImage(profile['profile_image_path'])
                                  : AssetImage('assets/images/profile_picture.png') as ImageProvider,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: IconButton(
                                icon: Icon(Icons.camera_alt),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StudentEditProfileScreen(studentId: widget.studentId),
                                    ),
                                  ).then((_) {
                                    _profileCubit.fetchProfile(widget.studentId);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        profile['full_name'] ?? 'اسم المستخدم',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(profile['email'] ?? 'البريد الالكتروني'),
                      SizedBox(height: 8),
                      Text(profile['number_un'] ?? 'الرقم الجامعي'),
                      SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StudentEditProfileScreen(studentId: widget.studentId),
                              ),
                            ).then((_) {
                              _profileCubit.fetchProfile(widget.studentId);
                            });
                          },
                          child: Text('تعديل الملف الشخصي'),
                        ),
                      ),
                      Divider(height: 40),
                      ListTile(
                        leading: Icon(Icons.description, color: const Color.fromARGB(255, 29, 72, 166)),
                        title: Text('شروط الاستخدام'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TermsScreen()),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.info, color: Color.fromARGB(255, 29, 72, 166)),
                        title: Text('حول التطبيق'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AboutScreen()),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.exit_to_app, color: Colors.red),
                        title: Text('تسجيل الخروج'),
                        onTap: () {
                          showDialog(
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
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is ProfileError) {
              return Center(child: Text(state.error));
            } else {
              return Center(child: Text('لا توجد بيانات'));
            }
          },
        ),
      ),
    );
  }
}
