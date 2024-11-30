import 'package:attendance_app/shared/theme.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/bloc_observer.dart';
import 'routes.dart';
import 'bloc_providers.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: BlocProviders.getProviders(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Attendance System',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.light,
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
        initialRoute: '/',
        routes: appRoutes,
      ),
    );
  }
}
