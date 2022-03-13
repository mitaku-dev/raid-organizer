import 'package:flutter/material.dart';

import 'constants.dart';

mixin AppTheme {

  static ThemeData get theme =>
   ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Colors.black87,
          contentTextStyle: TextStyle(
            color: highlightColor
          )
        ),
        canvasColor: secondaryColor,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: highlightColor,
        ),
        inputDecorationTheme: InputDecorationTheme(
          prefixStyle: const TextStyle(
            color: highlightColor
          ),
          suffixStyle: const TextStyle(
            color: highlightColor
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: highlightColor
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          )
        ),
     elevatedButtonTheme: ElevatedButtonThemeData(
       style:  ElevatedButton.styleFrom(shape : RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          //side: BorderSide(color: Colors.lightGreen),
        ),
        primary: highlightColor,
     )
     )
    );

}
