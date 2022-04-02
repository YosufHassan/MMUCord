//@dart=2.9
import 'package:flutter/material.dart';
import 'package:mmucord/object_graph.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mmucord/theme.dart';
// ignore: import_of_legacy_library_into_null_safe
// ignore: unused_import
import 'package:mmucord/user_interface/screens/boarding.dart';
// ignore: unused_import
import 'package:mmucord/user_interface/screens/users_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ObjectGraph.bootstrap();
  final firstPage = ObjectGraph.start(); // check if there is a user that is already logged in or not and act acrodingly
  
  runApp(MyApp(firstPage));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Widget firstPage;

  MyApp(this.firstPage);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MMUCord',
        theme: lightTheme(context), // set light theme
        darkTheme: darkTheme(context), // set dark theme
        home: firstPage, // set homepage to the 
        debugShowCheckedModeBanner: false // remove debug banner
        );
  }
}