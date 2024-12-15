import 'package:flutter/material.dart';
import './containerdialog.dart';
import '../data/database.dart';
import '../helpers/helpers.dart';

class ViewDiaryEntryWidget extends StatefulWidget {
  final String diaryId;
  final DiaryEntry diaryEntry;
  final Function updateEntries;

  const ViewDiaryEntryWidget({
    required this.diaryId,
    required this.diaryEntry,
    required this.updateEntries,
    super.key
  });

  @override
  State<ViewDiaryEntryWidget> createState() => _ViewDiaryEntryWidgetState();
}

class _ViewDiaryEntryWidgetState extends State<ViewDiaryEntryWidget> {
  TextEditingController textController = TextEditingController();
  bool editMode = false;

  updateDiary(BuildContext ctx, String entryId, String newEntry) async {
    AppDatabase db = AppDatabase();

    try{
      DiaryEntry newDiaryEntry = await db.updateDiaryEntry(entryId,newEntry);
      widget.updateEntries(newDiaryEntry, false);
      if(ctx.mounted) {
        Navigator.of(ctx).pop();
      }
    } catch(err) {
      print('DATABASE ERROR $err');
    }
    
  }

  @override
  void initState() {
    super.initState();
    textController.text = widget.diaryEntry.entry;
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ContainerDialog(
      confirmAction: editMode ? () => updateDiary(context, widget.diaryEntry.id, textController.text) : () => setState(() {
        editMode = true;
      }),
      confirmName: editMode ? "Update" : "Edit",
      content:SingleChildScrollView(
        child: SizedBox(
          width: 300,
          height: 300,
          child: Column(
            children:[
              Text(
                Helpers.getDateDisplaySimple(widget.diaryEntry.dateCreated),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize : 20,
                ),
              ), 
              const SizedBox(height: 10,),
              editMode
              ? TextField(
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
              )
              : Container(
                width: 300,
                height: 200,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.yellow[100],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                    widget.diaryEntry.entry,
                    
                ),
              ),
            ]
          ),
        ),
      ),
      title: const Text(
        'Diary Entry', 
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold
        ),  
      ),
    );
  }
}





