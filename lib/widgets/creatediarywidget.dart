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

  addDiary(BuildContext ctx) async {
    AppDatabase db = AppDatabase();

    try{
      await db.addDiary(diaryName: textController.text,);
      if(ctx.mounted) {
        Navigator.of(ctx).pop();
      }
    } catch(err) {
      print('DATABASE ERROR $err');
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return ContainerDialog(
      confirmAction: () => addDiary(context),
      content:TextField(
        maxLength: 30,
        controller: textController,
      ),
      confirmName: "Add",
      title: const Text(
        'Add Diary', 
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}





