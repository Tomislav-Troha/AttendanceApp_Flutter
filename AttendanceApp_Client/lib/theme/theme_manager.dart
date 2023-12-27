import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swimming_app_client/extensions/hex_color.dart';

Color lightPrimaryColor = Colors.blue.shade100;
Color lightBackgroundColor = Colors.blue.shade50;

ThemeData themeLight = ThemeData(
  textTheme: GoogleFonts.poppinsTextTheme(),
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: lightPrimaryColor,
    brightness: Brightness.light,
    onPrimary: Colors.black,
    background: lightBackgroundColor,
    onBackground: Colors.black,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
      backgroundColor: lightPrimaryColor,
      foregroundColor: lightBackgroundColor,
      fixedSize: const Size(200, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: const TextStyle(color: Colors.black),
    hintStyle: const TextStyle(color: Colors.black),
    fillColor: lightBackgroundColor,
    filled: true,
    floatingLabelStyle: TextStyle(color: lightPrimaryColor, letterSpacing: 1.3),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
  ),
);

Color darkPrimaryColor = HexColor("004266");
Color darkBackgroundColor = HexColor("002133");

ThemeData themeDark = ThemeData(
  textTheme: GoogleFonts.poppinsTextTheme(),
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: darkPrimaryColor,
    brightness: Brightness.dark,
    onPrimary: Colors.white,
    background: darkBackgroundColor,
    onBackground: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
      backgroundColor: darkPrimaryColor,
      foregroundColor: darkBackgroundColor,
      fixedSize: const Size(200, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: const TextStyle(color: Colors.white),
    floatingLabelStyle:
        const TextStyle(color: Colors.white, letterSpacing: 1.3),
    hintStyle: const TextStyle(color: Colors.white),
    fillColor: darkBackgroundColor,
    filled: true,
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: darkBackgroundColor,
  ),
);
