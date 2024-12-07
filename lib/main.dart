import 'package:flutter/material.dart';
import './screens/homescreen.dart';
import './screens/diaryscreen.dart';
//import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // if (Platform.isWindows || Platform.isLinux) {
  //   // Initialize FFI
  //   sqfliteFfiInit();
  // }
  // Change the default factory. On iOS/Android, if not using `sqlite_flutter_lib` you can forget
  // this step, it will use the sqlite version available on the system.
  //databaseFactory = databaseFactoryFfi;
  runApp(const MyDiary());
}

class MyDiary extends StatelessWidget {
  const MyDiary({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
      routes: {
        Home.routeName : (context) =>  const Home(),
        DiaryScreen.routeName : (context) => const DiaryScreen()
      }
    );
  }
}
