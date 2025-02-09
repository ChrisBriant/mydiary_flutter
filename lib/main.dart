import 'package:flutter/material.dart';
import './screens/homescreen.dart';
import './screens/diaryscreen.dart';

void main() {
  runApp(const MyDiary());
}

class MyDiary extends StatelessWidget {
  const MyDiary({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Diary',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.brown.shade100,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.amber),
          )
        ),
        appBarTheme: AppBarTheme(
          color: Colors.grey.shade800,
          foregroundColor: Colors.white
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
      onGenerateRoute: (settings)  {
        if (settings.name == DiaryScreen.routeName) {
          // Cast the arguments to the correct
          // type: ScreenArguments.
          final args = settings.arguments as Map<String,dynamic>;

          // Then, extract the required data from
          // the arguments and pass the data to the
          // correct screen.
          return MaterialPageRoute(
            builder: (context) {
              return DiaryScreen(diary: args['diary'],);
            },
          );
        } else {
          return MaterialPageRoute(
            builder: (context) {
              return const Home();
            },
          );
        }
      },
      routes: {
        Home.routeName : (context) =>  const Home(),
      }
    );
  }
}
