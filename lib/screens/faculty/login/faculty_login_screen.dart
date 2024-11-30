import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:email_validator/email_validator.dart';

import '../../../blocs/faculty_bloc/auth/faculty_auth_cubit.dart';
import '../../../blocs/faculty_bloc/auth/faculty_auth_states.dart';
import '../../../services/api_service.dart';
import '../../../shared/widgets/network_sensitive_button.dart';
import '../faculty_home_screen.dart';

class FacultyLoginScreen extends StatefulWidget {
  @override
  _FacultyLoginScreenState createState() => _FacultyLoginScreenState();
}

class _FacultyLoginScreenState extends State<FacultyLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true; // Track whether the password is obscured

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FacultyAuthCubit(ApiService()),
      child: BlocConsumer<FacultyAuthCubit, FacultyAuthState>(
        listener: (context, state) {
          if (state is AuthLoggedInFaculty) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => FacultyHomeScreen(
                  facultyId: state.data['id'],
                ),
              ),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('كلمة المرور أو الإيميل غير صحيح')),
            );
            debugPrint('AuthError: ${state.error}');
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('تسجيل الدخول إلى حسابك'),
              automaticallyImplyLeading: false,
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: 40),
                      Text(
                        'تسجيل الدخول لأعضاء هيئة التدريس',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 40),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'البريد الإلكتروني',
                            labelText: 'البريد الإلكتروني',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(),
                          ),
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إدخال البريد الإلكتروني';
                            } else if (!EmailValidator.validate(value)) {
                              return 'يرجى إدخال بريد إلكتروني صحيح';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'كلمة المرور',
                            labelText: 'كلمة المرور',
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(),
                          ),
                          obscureText: _obscurePassword,
                          controller: passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إدخال كلمة المرور';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        child: NetworkSensitiveButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {

                                final email = emailController.text;
                                final password = passwordController.text;

                                context.read<FacultyAuthCubit>().loginFaculty({
                                  'email': email,
                                  'password': password,
                                });
                            }
                          }, buttonText: 'تسجيل الدخول',
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ليس لديك حساب بعد؟',
                            style: TextStyle(fontSize: 16),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/faculty_registration');
                            },
                            child: Text(
                              'قم بالتسجيل',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
