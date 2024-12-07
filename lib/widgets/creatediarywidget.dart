import 'package:flutter/material.dart';
import './containerdialog.dart';
import '../data/database.dart';

class CreateDiaryWidget extends StatefulWidget {
  const CreateDiaryWidget({super.key});

  @override
  State<CreateDiaryWidget> createState() => _CreateDiaryWidgetState();
}

class _CreateDiaryWidgetState extends State<CreateDiaryWidget> {
  TextEditingController textController = TextEditingController();

  addDiary() async {
    AppDatabase db = AppDatabase();

    try{
      await db.addDiary(diaryName: textController.text);
    } catch(err) {
      print('DATABASE ERROR $err');
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return ContainerDialog(
      confirmAction: () => addDiary(),
      content:Container(
        child: TextField(
          controller: textController,
        ),
      ),
      confirmName: "Add",
      title: const Text('Add Diary'),
    );
  }
}





