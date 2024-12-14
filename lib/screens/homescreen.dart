import 'package:flutter/material.dart';
import '../widgets/creatediarywidget.dart';
import '../widgets/diarylistwidget.dart';

class Home extends StatelessWidget {
  static const String routeName = "/homescreen";
  static const String aboutText = "This is your personal sanctuary for reflection and growth. Create a unique digital diary tailored to your style, where you can freely express yourself through words and images.";

  const Home({super.key});

  @override
  Widget build(BuildContext context) {

    void showAddDiaryDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const CreateDiaryWidget();
        },
      );
    }

    void showDiaryListDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const DiaryListWidget();
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Diary'),
      ),
      body: Column(
        children: [
          Image.asset('assets/diary_banner_image.png'),
          const Text(aboutText),
          ElevatedButton(
            onPressed: () => showDiaryListDialog(), 
            child: const Text('Open Diary')
          ),
          ElevatedButton(
            onPressed: () => showAddDiaryDialog(), 
            child: const Text('Create Diary')
          ),

        ]
        
      ),
    );
  }
}