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

  const DiaryScreen({
    super.key
  });

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>?;
    String title = "Diary";
    Diary? diary;

    if(args != null) {
      title = args['diary'].name;
      diary = args['diary'];
    }

    void updateDiaryEntries(newEntry, adding) {
      //DiaryEntry replaceEntry = diary!.entries.firstWhere((diaryEntry) => diaryEntry.id == newEntry.id);
      int insertIdx = diary!.entries.indexWhere((DiaryEntry d) => d.id == newEntry.id);
      diary.entries.removeWhere((DiaryEntry d) => d.id == newEntry.id);
      print('I NEED TO INSERT AT $insertIdx');

      setState(() {
        if(adding) {
          diary!.entries.insert(0,newEntry);
        } else {
          diary!.entries.insert(insertIdx,newEntry);
        }
        
      });
    }

    void showAddDiaryDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddDiaryEntryWidget(diaryId: diary!.id, updateEntries: updateDiaryEntries,);
        },
      );
    }



    void showViewDiaryEntryDialog(DiaryEntry entry) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ViewDiaryEntryWidget(diaryId: diary!.id, diaryEntry: entry, updateEntries: updateDiaryEntries,);
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
      String jsonData = jsonEncode(diary!.toJson());

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
          SizedBox(
            height: 300,
            child: ListView.builder(
              itemCount: diary!.entries.length,
              itemBuilder: (ctx, idx) => InkWell(
                onLongPress: () => showViewDiaryEntryDialog(diary!.entries[idx]),
                child: ListTile(
                    key: ValueKey(diary!.entries[idx].id),
                    title: Text(
                      diary.entries[idx].entry,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1, // Limit to one line
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.brown, 
                        fontSize: 20.0,
                      ),
                    ),
                    subtitle: Text(
                      Helpers.getDisplayDate(diary!.entries[idx].dateCreated),
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