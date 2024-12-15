import 'package:flutter/material.dart';
import './containerdialog.dart';
import '../data/database.dart';
import '../helpers/helpers.dart';
import '../widgets/timeselectwidget.dart';

class AddDiaryEntryWidget extends StatefulWidget {
  final String diaryId;
  final Function updateEntries;
  final DateTime diaryEntryDateTime;

  const AddDiaryEntryWidget({
    required this.diaryId,
    required this.updateEntries,
    required this.diaryEntryDateTime,
    super.key
  });

  @override
  State<AddDiaryEntryWidget> createState() => _AddDiaryEntryWidgetState();
}

class _AddDiaryEntryWidgetState extends State<AddDiaryEntryWidget> {
  TextEditingController textController = TextEditingController();
  int selectedHour = 0;
  int selectedMinute = 0;

  addDiary(BuildContext ctx) async {
    AppDatabase db = AppDatabase();
    DateTime entryDate = DateTime.now();
    if( (entryDate.day != widget.diaryEntryDateTime.day) || (entryDate.month != widget.diaryEntryDateTime.month) || (entryDate.year != widget.diaryEntryDateTime.year)) {
      entryDate = DateTime(
        widget.diaryEntryDateTime.year,
        widget.diaryEntryDateTime.month,
        widget.diaryEntryDateTime.day,
        selectedHour,
        selectedMinute
      );
    }
    try{
      DiaryEntry newDiaryEntry = await db.addDiaryEntry(diaryId: widget.diaryId, entry: textController.text, diaryEntryDateTime: entryDate);
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
          height: 350,
          child: Column(
          
            children:[
              Builder(
                builder: (ctx) {
                  DateTime now = DateTime.now();

                  if( (now.day == widget.diaryEntryDateTime.day) && (now.month == widget.diaryEntryDateTime.month) && (now.year == widget.diaryEntryDateTime.year)) {
                    return Text(
                      Helpers.getDateDisplaySimple(DateTime.now()),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize : 20,
                      ),
                    );
                  } else {
                    return Row(
                      children: [
                        Text(
                          Helpers.getDateOnlyDisplaySimple(widget.diaryEntryDateTime),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize : 20,
                          ),
                        ),
                        // SizedBox(
                        //   width: 50,
                        //   child: TimeSelectWidget(
                        //     hour: 0, 
                        //     minute: 0, 
                        //     onUpdate: () {}
                        //   ),
                        // )
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TimeSelectWidget(
                              hour: 0, 
                              minute: 0, 
                              onUpdate: (h,m) {
                                selectedHour = h;
                                selectedMinute = m;
                              }
                            ),
                        ),
                      ],

                    );
                  } 
                }
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
      title: const Text(
        'Add a Diary Entry',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}





