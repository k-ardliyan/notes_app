import 'package:flutter/material.dart';
import 'package:notes_app/pages/splash_page.dart';
import 'package:notes_app/pages/home_page.dart';
// import 'package:notes_app/pages/detail_page.dart';
import 'package:notes_app/pages/archive_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Note App',
      initialRoute: '/',
      routes: {
        '/': (context) => SplashPage(),
        '/home': (context) => HomePage(),
        // '/detail': (context) => DetailPage(),
        '/archive': (context) => ArchivePage(),
      },
    );
  }
}
