import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Color primaryColor = Color(0xFF1d48a6);
final MaterialColor primarySwatch = MaterialColor(
  primaryColor.value,
  <int, Color>{
    50: primaryColor.withOpacity(0.1),
    100: primaryColor.withOpacity(0.2),
    200: primaryColor.withOpacity(0.3),
    300: primaryColor.withOpacity(0.4),
    400: primaryColor.withOpacity(0.5),
    500: primaryColor.withOpacity(0.6),
    600: primaryColor.withOpacity(0.7),
    700: primaryColor.withOpacity(0.8),
    800: primaryColor.withOpacity(0.9),
    900: primaryColor.withOpacity(1.0),
  },
);

// Light Theme
final ThemeData  lightTheme = ThemeData(
  // primaryColor: primaryColor,
  primarySwatch: primarySwatch,
  scaffoldBackgroundColor: Colors.white,
  tabBarTheme: const TabBarTheme(
    labelColor: Colors.black,
  ),
  appBarTheme: const AppBarTheme(
    
    backgroundColor: Colors.white,
    elevation: 0.0,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: primaryColor,
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
  ),
  iconTheme: const IconThemeData(
    color: primaryColor, 
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    elevation: 20.0,
    selectedItemColor: primaryColor,
  ),
    buttonTheme: ButtonThemeData(
    buttonColor: primaryColor, 
    textTheme: ButtonTextTheme.primary, 
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0), 
    ),
     ),
  
    elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      // primary: primaryColor, 
      // onPrimary: Colors.white,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(8.0), 
      // ),
    ),
  ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: primaryColor, 
    foregroundColor: Colors.white, 
  ),


  textTheme: const TextTheme(
    // bodyText1: TextStyle(color: Colors.black87),
    // bodyText2: TextStyle(color: Colors.black87),
    // headline6: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
  ),
);

// Dark Theme
final ThemeData darkTheme = ThemeData(
  primaryColor: primaryColor,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    elevation: 0.0,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: primaryColor, 
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
    ),
  ),
  textTheme: const TextTheme(
    // bodyText1: TextStyle(color: Colors.white),
    // bodyText2: TextStyle(color: Colors.white),
    // headline6: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  ),

    buttonTheme: ButtonThemeData(
    buttonColor: primaryColor, 
    textTheme: ButtonTextTheme.primary, 
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0), 
    ),
  ),

    elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      // primary: primaryColor,
      // onPrimary: Colors.white, 
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(8.0), 
      // ),
    ),
  ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: primaryColor, 
    foregroundColor: Colors.white, 
  ),
);
