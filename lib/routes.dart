import 'package:flutter/material.dart';
import 'screens/faculty/login/faculty_login_screen.dart';
import 'screens/faculty/register/faculty_registration_screen.dart';
import 'shared/splash/splash_screen.dart';
import 'shared/onboarding_screen.dart';
import 'screens/login_options_screen.dart';
import 'screens/student/student_login_screen.dart';
import 'screens/student/student_registration_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {

  '/': (context) => SplashScreen(),
  '/onboarding': (context) => OnboardingScreen(),
  '/login_options': (context) => LoginOptionsScreen(),
  '/student_login': (context) => StudentLoginScreen(),
  '/faculty_login': (context) => FacultyLoginScreen(),
  '/student_registration': (context) => StudentRegistrationScreen(),
  '/faculty_registration': (context) => FacultyRegistrationScreen(),
};
