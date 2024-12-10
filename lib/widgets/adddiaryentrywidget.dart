import 'package:flutter/material.dart';
import './containerdialog.dart';
import '../data/database.dart';
import '../helpers/helpers.dart';

class AddDiaryEntryWidget extends StatefulWidget {
  final String diaryId;
  final Function updateEntries;
  final DateTime? diaryEntryDateTime;

  const AddDiaryEntryWidget({
    required this.diaryId,
    required this.updateEntries,
    this.diaryEntryDateTime,
    super.key
  });

  @override
  State<AddDiaryEntryWidget> createState() => _AddDiaryEntryWidgetState();
}

class _AddDiaryEntryWidgetState extends State<AddDiaryEntryWidget> {
  TextEditingController textController = TextEditingController();

  addDiary(BuildContext ctx) async {
    AppDatabase db = AppDatabase();

    try{
      DiaryEntry newDiaryEntry = await db.addDiaryEntry(diaryId: widget.diaryId, entry: textController.text);
      widget.updateEntries(newDiaryEntry, true);
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
      content:SingleChildScrollView(
        child: SizedBox(
          width: 300,
          height: 300,
          child: Column(
          
            children:[
              Text(
                Helpers.getDateDisplaySimple(DateTime.now()),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize : 20,
                ),
              ), 
              const SizedBox(height: 10,),
              TextField(
                controller: textController,
                maxLines: 9,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.yellow[100], // Pale yellow color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                    borderSide: BorderSide.none, // Remove the border
                  ),
                ),
              ),
            ]
          ),
        ),
      ),
      confirmName: "Add",
      title: const Text('Add a Diary Entry'),
    );
  }
}





