import 'package:flutter/material.dart';
import '../data/database.dart';
import '../widgets/adddiaryentrywidget.dart';
import '../widgets/viewdiaryentrywidget.dart';
import '../helpers/helpers.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DiaryScreen extends StatefulWidget {
  static const String routeName = "/diaryscreen";

  final Diary diary;

  const DiaryScreen({
    required this.diary,
    super.key
  });

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
    List<DiaryEntry> diaryEntries = [];
    String title = "Diary";
    DateTime selectedDate =  DateTime.now();
    //Diary diary = widget.diary;

    List<DiaryEntry> getDiaryEntriesByDate(DateTime? searchDate) {
      List<DiaryEntry> newDiaryEntries = widget.diary.entries;

      DateTime sd = searchDate ?? DateTime.now();

      newDiaryEntries = newDiaryEntries.where((DiaryEntry de) => (de.dateCreated.day == sd.day) && (de.dateCreated.month == sd.month) && (de.dateCreated.year == sd.year)).toList();
      print('NEW DIARY ENTRIES $newDiaryEntries');
      return newDiaryEntries;
    }
    
    @override
    void initState() {
      //final args = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>?;
      print("DO I GET HERE");
      diaryEntries = getDiaryEntriesByDate(DateTime.now());
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    //final args = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>?;




    void updateDiaryEntries(newEntry, adding) {
      //DiaryEntry replaceEntry = widget.diary.entries.firstWhere((diaryEntry) => diaryEntry.id == newEntry.id);
      int insertIdx = diaryEntries.indexWhere((DiaryEntry d) => d.id == newEntry.id);
      diaryEntries.removeWhere((DiaryEntry d) => d.id == newEntry.id);
      print('I NEED TO INSERT AT $insertIdx');

      setState(() {
        if(adding) {
          diaryEntries.insert(0,newEntry);
        } else {
          diaryEntries.insert(insertIdx,newEntry);
        }
        
      });
    }

    void showAddDiaryDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddDiaryEntryWidget(diaryId: widget.diary.id, updateEntries: updateDiaryEntries,);
        },
      );
    }



    void showViewDiaryEntryDialog(DiaryEntry entry) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ViewDiaryEntryWidget(diaryId: widget.diary.id, diaryEntry: entry, updateEntries: updateDiaryEntries,);
        },
      );
    }

    Future<void> downloadJsonToFile(String jsonData) async {
    
      final Directory? directory = await getDownloadsDirectory();
      if(directory != null) {
        try {
          final file = File('${directory.path}/diary_data.json');
          await file.writeAsString(jsonData);
          print('I SHOULD DOWNLOAD ${directory.path}/diary_data.json');
        } catch(err) {
          print("An error occured $err");
        }

      } else {
        throw Exception('Download is not possible');
      }


      //
    }

    void exportDiary() async {
      String jsonData = jsonEncode(widget.diary.toJson());

      print("Json Output $jsonData");
      try {
        await downloadJsonToFile(jsonData);
      } catch(err) {
        print('AN ERROR OCCURRED, $err');
      }
      
    }




    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          const Text(""),
          Row(
            children: [
              ElevatedButton(
                onPressed: () => showAddDiaryDialog(), 
                child: const Text('Add Entry')
              ),
              ElevatedButton(
                onPressed: () => exportDiary(), 
                child: const Text("Export Diary")
              )
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  DateTime prevDate = selectedDate.subtract(const Duration(days: 1));

                  List<DiaryEntry> newEntries = getDiaryEntriesByDate(prevDate);
                  setState(() {
                    diaryEntries = newEntries;
                  });
                  selectedDate = prevDate;
                }, 
                icon: Icon(Icons.arrow_back),
              ),
            ],
          ),
          SizedBox(
            height: 300,
            child: ListView.builder(
              itemCount: diaryEntries.length,
              itemBuilder: (ctx, idx) => InkWell(
                onLongPress: () => showViewDiaryEntryDialog(diaryEntries[idx]),
                child: ListTile(
                    key: ValueKey(diaryEntries[idx].id),
                    title: Text(
                      diaryEntries[idx].entry,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1, // Limit to one line
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.brown, 
                        fontSize: 20.0,
                      ),
                    ),
                    subtitle: Text(
                      Helpers.getDisplayDate(diaryEntries[idx].dateCreated),
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.blue, 
                        fontSize: 16.0,
                      ),
                    ),
                    dense: true,
                ),
              )
            ),
          )
        ],
      ),
    );
  }
}