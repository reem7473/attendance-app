import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../services/api_service.dart';
import 'bloc/profile_cubit.dart';
import 'bloc/profile_state.dart';
import 'change_password_screen.dart';
import 'edit_email_screen.dart';
import 'edit_name_dialog.dart';
import 'edit_un_number_dialog.dart';

class StudentEditProfileScreen extends StatelessWidget {
  final int studentId;

  StudentEditProfileScreen({required this.studentId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProfileStudentCubit(ApiService())..fetchProfile(studentId),
      child: StudentEditProfileView(
        studentId: studentId,
      ),
    );
  }
}

class StudentEditProfileView extends StatefulWidget {
  final int studentId;

  const StudentEditProfileView({super.key, required this.studentId});
  @override
  _StudentEditProfileViewState createState() => _StudentEditProfileViewState();
}

class _StudentEditProfileViewState extends State<StudentEditProfileView> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل الملف الشخصي',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: BlocConsumer<ProfileStudentCubit, ProfileStudentState>(
        listener: (context, state) {
          if (state is ProfileUploaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('تم تحديث صورة الملف الشخصي ينجاح')),
            );
            context.read<ProfileStudentCubit>().fetchProfile(widget.studentId);
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: <Widget>[
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: state.profile['profile_image_path'] !=
                                null
                            ? NetworkImage(state.profile['profile_image_path'])
                            : _image != null
                                ? FileImage(_image!) as ImageProvider
                                : AssetImage(
                                        'assets/images/profile_picture.png')
                                    as ImageProvider,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(Icons.camera_alt),
                          onPressed: _pickImage,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_image != null)
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        context
                            .read<ProfileStudentCubit>()
                            .uploadImage(_image!, state.profile['id']);
                      },
                      child: Text('تأكيد'),
                    ),
                  ),
                SizedBox(height: 16),
                ListTile(
                  title: Text(state.profile['full_name'] ?? 'اسم المستخدم'),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            EditNameDialog(studentId: state.profile['id']),
                      ).then((_) {
                        context
                            .read<ProfileStudentCubit>()
                            .fetchProfile(widget.studentId);
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text(state.profile['number_un'] ?? 'الرقم الجامعي'),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            EditUnNumberDialog(studentId: state.profile['id']),
                      ).then((_) {
                        context
                            .read<ProfileStudentCubit>()
                            .fetchProfile(widget.studentId);
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text(state.profile['email'] ?? 'البريد الإلكتروني'),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditEmailScreen(
                                studentId: state.profile['id'])),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ListTile(
                  tileColor: const Color.fromARGB(255, 29, 72, 166),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  title: Center(
                      child: Text(
                    'تغيير كلمة المرور',
                    style: TextStyle(color: Colors.white),
                  )),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePasswordScreen(
                                studentId: state.profile['id'],
                              )),
                    ).then((_) {
                      context
                          .read<ProfileStudentCubit>()
                          .fetchProfile(widget.studentId);
                    });
                  },
                ),
              ],
            );
          } else if (state is ProfileError) {
            return Center(child: Text(state.error));
          } else {
            return Center(child: Text('لا توجد بيانات'));
          }
        },
      ),
    );
  }
}
