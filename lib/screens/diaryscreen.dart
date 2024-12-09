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
    Diary? diaryState;

    List<DiaryEntry> getDiaryEntriesByDate(DateTime? searchDate) {
      List<DiaryEntry> newDiaryEntries = diaryState!.entries;

      DateTime sd = searchDate ?? DateTime.now();

      newDiaryEntries = newDiaryEntries.where((DiaryEntry de) => (de.dateCreated.day == sd.day) && (de.dateCreated.month == sd.month) && (de.dateCreated.year == sd.year)).toList();
      newDiaryEntries.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
      print('NEW DIARY ENTRIES $newDiaryEntries');
      return newDiaryEntries;
    }
    
    @override
    void initState() {
      diaryState = widget.diary;
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
      //int insertIdx = diaryEntries.indexWhere((DiaryEntry d) => d.id == newEntry.id);
      diaryEntries.removeWhere((DiaryEntry d) => d.id == newEntry.id);
      diaryState!.entries.removeWhere((DiaryEntry d) => d.id == newEntry.id);
      //print('I NEED TO INSERT AT $insertIdx');

      setState(() {
        //Code below no longer needed as it is sorting the entries
        // if(adding) {
        //   diaryEntries.insert(0,newEntry);
        // } else {
        //   diaryEntries.insert(insertIdx,newEntry);
        // }
        diaryEntries.add(newEntry);
        diaryEntries.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
        //Update the diary object
        List<DiaryEntry> newAndExistingEntries =  [...diaryState!.entries,newEntry];
        
        diaryState!.entries = newAndExistingEntries;
      });
    }

    void showAddDiaryDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddDiaryEntryWidget(
            diaryId: widget.diary.id, 
            updateEntries: updateDiaryEntries,
            diaryEntryDateTime: selectedDate,
          );
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
        automaticallyImplyLeading: false,
        title: Text(widget.diary.name),
      ),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
              IconButton(
                onPressed: () => showAddDiaryDialog(), 
                icon: const Icon(Icons.home)
              ),
              IconButton(
                onPressed: () => showAddDiaryDialog(), 
               icon: const Icon(Icons.library_add_outlined)
              ),
              IconButton(
                onPressed: () => exportDiary(), 
                icon: const Icon(Icons.download)
              ),
              IconButton(
                onPressed: (){}, 
                icon: const Icon(Icons.import_contacts)
              )
      ],
      body: ColoredBox(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(""),
            // Row(
            //   children: [
            //     ElevatedButton(
            //       onPressed: () => showAddDiaryDialog(), 
            //       child: const Text('Add Entry')
            //     ),
            //     IconButton(
            //       onPressed: () => exportDiary(), 
            //       icon: Icon(Icons.download)
            //     )
            //   ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  icon: const Icon(Icons.arrow_back),
                ),
                Text(Helpers.getDisplayDate(selectedDate),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Builder(
                  builder: (ctx) {
                    DateTime now = DateTime.now();
        
                    if( (now.day == selectedDate.day) && (now.month == selectedDate.month) && (now.year == selectedDate.year)) {
                      return const IconButton(
                        onPressed: null, 
                        icon: Icon(Icons.arrow_forward)
                      );
                    } else {
                      return IconButton(
                        onPressed:
                          () {
                          DateTime nextDate = selectedDate.add(const Duration(days: 1));
                      
                          List<DiaryEntry> newEntries = getDiaryEntriesByDate(nextDate);
                          setState(() {
                            diaryEntries = newEntries;
                          });
                          selectedDate = nextDate;
                        }, 
                        icon: const Icon(Icons.arrow_forward),
                      );
                    }
                  },
                ),    
              ],
            ),
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.yellow.shade200,
                borderRadius: BorderRadius.circular(10)
              ),
              
              height: 300,
              child: 
                diaryEntries.isEmpty
                ? Text(
                  'You have no diary entries for ${Helpers.getDisplayDate(selectedDate)}!',
                  style:  const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                )
                : ListView.builder(
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
      ),
    );
  }
}