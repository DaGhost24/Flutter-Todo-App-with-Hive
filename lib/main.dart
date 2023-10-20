import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/pages/home_page.dart';

void main() async{

  //init our hive NoSql database
  await Hive.initFlutter();

  //To load everything on the hive while the app loads
  var box= await Hive.openBox('mybox');


  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent)
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do App',
      home: HomePage(),
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
    );
  }
}
