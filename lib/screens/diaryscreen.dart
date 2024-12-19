import 'package:flutter/material.dart';
import '../data/database.dart';
import '../widgets/adddiaryentrywidget.dart';
import '../widgets/viewdiaryentrywidget.dart';
import '../helpers/helpers.dart';
import '../widgets/calendarwidget.dart';
import '../widgets/filelistwidget.dart';
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
    Map<DateTime,Function> activeDiaryDays = {};

    List<DiaryEntry> getDiaryEntriesByDate(DateTime? searchDate) {
      List<DiaryEntry> newDiaryEntries = diaryState!.entries;

      DateTime sd = searchDate ?? DateTime.now();

      newDiaryEntries = newDiaryEntries.where((DiaryEntry de) => (de.dateCreated.day == sd.day) && (de.dateCreated.month == sd.month) && (de.dateCreated.year == sd.year)).toList();
      newDiaryEntries.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
      return newDiaryEntries;
    }

    setCurrentDate(DateTime newDate) {
      setState(() {
        selectedDate = newDate;
        diaryEntries = getDiaryEntriesByDate(newDate);
      });
    }

    //After an import the diary needs to be reloaded
    updateDiaryAfterImport(Diary newDiary, DateTime diaryDate) {
      for ( DiaryEntry de in newDiary.entries) {
        activeDiaryDays[DateTime(de.dateCreated.year,de.dateCreated.month,de.dateCreated.day)] = setCurrentDate;
      }
      setState(() {
        diaryState = newDiary;
        diaryEntries = getDiaryEntriesByDate(diaryDate);
      });
    }
    
    @override
    void initState() {
      diaryState = widget.diary;
      //Load the calendar with the dates that have entries
      for ( DiaryEntry de in diaryState!.entries) {
        activeDiaryDays[DateTime(de.dateCreated.year,de.dateCreated.month,de.dateCreated.day)] = setCurrentDate;
      }
      diaryEntries = getDiaryEntriesByDate(DateTime.now());
      super.initState();
    }

  @override
  Widget build(BuildContext context) {

    void updateDiaryEntries(newEntry, adding) {
      diaryEntries.removeWhere((DiaryEntry d) => d.id == newEntry.id);
      diaryState!.entries.removeWhere((DiaryEntry d) => d.id == newEntry.id);

      setState(() {
        diaryEntries.add(newEntry);
        diaryEntries.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
        //Update the diary object
        List<DiaryEntry> newAndExistingEntries =  [...diaryState!.entries,newEntry];
        
        diaryState!.entries = newAndExistingEntries;
        //For updating the calendar
        for ( DiaryEntry de in diaryState!.entries) {
          activeDiaryDays[DateTime(de.dateCreated.year,de.dateCreated.month,de.dateCreated.day)] = setCurrentDate;
        }
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

    handleDeleteDiaryEntry(DiaryEntry entry, Diary diary) async {
      showDialog(
        context: context, 
        builder: (BuildContext ctx) => AlertDialog(
          title: const Text("Delete Diary Entry", style : TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('Are you sure you want to delete this diary entry?'),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () async {
                AppDatabase db = AppDatabase();
                Diary newDiary =  await db.deleteDiaryEntry(entry.id, diary);
                updateDiaryAfterImport(newDiary, entry.dateCreated);
                if(ctx.mounted) {
                  Navigator.of(ctx).pop();
                }
              }, 
              child: const Text("Yes")
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("No")
            ),
          ],
        )
      );
    }

    Future<void> downloadJsonToFile(String jsonData) async {
    
      final Directory? directory = await getDownloadsDirectory();
      if(directory != null) {
        try {
          
          final file = File('${directory.path}/${widget.diary.name}.json');
          await file.writeAsString(jsonData);
        } catch(err) {
          //print("An error occured $err");
        }

      } else {
        throw Exception('Download is not possible');
      }
    }

    void exportDiary(BuildContext ctx) async {
      String jsonData = jsonEncode(widget.diary.toJson());

      try {
        await downloadJsonToFile(jsonData);
        if(ctx.mounted) {
          ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
            content: Text('Your diary has been exported')
          ));
        }
      } catch(err) {
        //print('AN ERROR OCCURRED, $err');
      }
    }

    void showFileListDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return FileListWidget(diary: widget.diary, onAfterImport: updateDiaryAfterImport,);
        },
      );
    }

    handleDeleteDiary(BuildContext ctx) {
      showDialog(
        context: ctx, 
        builder: (ctx) => AlertDialog(
        title: const Text('Delete Diary', 
          style: TextStyle(fontWeight: FontWeight.bold
          ),
          textAlign: TextAlign.center,
        ),
        content: Text('Are you sure you want to delete ${widget.diary.name}?', textAlign: TextAlign.center,),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
            ElevatedButton(
              onPressed: () async {
                AppDatabase db = AppDatabase();
                await db.deleteDiary(widget.diary.id);
                if(ctx.mounted) {
                  Navigator.of(ctx).popAndPushNamed('/homescreen');
                }
              }, 
              child: const Text('Yes')
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(), 
              child: const Text('No')
            )
          ],
        )
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.diary.name),
      ),
      persistentFooterAlignment: AlignmentDirectional.center,
      floatingActionButton: CircleAvatar(
        child: IconButton(
          onPressed: () => showAddDiaryDialog(), 
          icon: const Icon(Icons.library_add_outlined)
        ),
      ),
      bottomNavigationBar: ColoredBox(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).popAndPushNamed('/homescreen'), 
              icon: const Icon(Icons.home)
            ),
            IconButton(
              onPressed: () => showAddDiaryDialog(), 
              icon: const Icon(Icons.library_add_outlined)
            ),
            IconButton(
              onPressed: () => exportDiary(context), 
              icon: const Icon(Icons.download)
            ),
            IconButton(
              onPressed: () => showFileListDialog(), 
              icon: const Icon(Icons.import_contacts)
            ),
            IconButton(
              onPressed: () => handleDeleteDiary(context), 
              icon: const Icon(Icons.delete_forever)
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Card(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: SizedBox(
                    height: 190,
                    child: CalendarWidget(
                      selectedDate: selectedDate, 
                      dateActions: activeDiaryDays,
                      currentClickAction: setCurrentDate,
                    )
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Card(
                child: SizedBox(
                  width : double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          DateTime prevDate = selectedDate.subtract(const Duration(days: 1));
                          
                          List<DiaryEntry> newEntries = getDiaryEntriesByDate(prevDate);
                          setState(() {
                            diaryEntries = newEntries;
                            selectedDate = prevDate;
                    
                          });
                         
                        }, 
                        icon: const Icon(Icons.arrow_back),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .4,
                        height: 70,
                        child: Text(Helpers.getDisplayDate(selectedDate),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
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
                                  selectedDate = nextDate;
                                });
                                
                              }, 
                              icon: const Icon(Icons.arrow_forward),
                            );
                          }
                        },
                      ),    
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
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
                  textAlign: TextAlign.center,
                )
                : ListView.builder(
                  itemCount: diaryEntries.length,
                  itemBuilder: (ctx, idx) => InkWell(
                      onLongPress: () => showViewDiaryEntryDialog(diaryEntries[idx]),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 5, left: 10, right: 10, top: 5),
                        decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 4,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),

                      child: ListTile(
                          key: ValueKey(diaryEntries[idx].id),
                          title: Text(
                            diaryEntries[idx].entry,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1, // Limit to one line
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 1, 45, 80), 
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
                          trailing: IconButton(
                            onPressed: () => handleDeleteDiaryEntry(diaryEntries[idx], widget.diary), 
                            icon: const Icon(Icons.delete_forever, color: Colors.red,)
                          ),
                          dense: true,
                      ),
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