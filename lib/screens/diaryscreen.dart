import 'package:flutter/material.dart';
import '../data/database.dart';
import '../widgets/adddiaryentrywidget.dart';
import '../widgets/viewdiaryentrywidget.dart';
import '../helpers/helpers.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          const Text(""),
          ElevatedButton(
            onPressed: () => showAddDiaryDialog(), 
            child: const Text('Add Entry')
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