import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mydiary/data/database.dart';
import './containerdialog.dart';
import '../helpers/helpers.dart';
import '../widgets/loadingwidget.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


class FileListWidget extends StatelessWidget {
  final Diary diary;
  final Function onAfterImport; 

  const FileListWidget({
    required this.diary,
    required this.onAfterImport,
    super.key
  });

  Future<List<Widget>> getFileList(BuildContext ctx) async {
    final Directory? directory = await getDownloadsDirectory();
    if(directory != null) {
      try {
        List<FileSystemEntity> fileList = await directory.list().toList();
        List filteredFileList = fileList.where((item) => item.path.endsWith(".json")).toList();
        //Transform the files list into a list of widgets which can be used
        List<Widget> savedFiles = [];
        for (FileSystemEntity f in filteredFileList) {
          savedFiles.add(
            InkWell(
                onTap: () => showImportFileDialog(ctx,Helpers.stripToFileName(f.path),f),
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
                  ]
                  ),
                  child: ListTile(
                    key: ValueKey(f.hashCode),
                    title: Text(
                      Helpers.stripToFileName(f.path),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 1, 45, 80), 
                        fontSize: 20.0,
                      ),
                    ),
                    dense: true,
                  ),
                ),
              ),
          );
          
        }
        return savedFiles;
      } catch(err) {
        throw Exception('Unable to retrieve files');
      }
    } else {
      throw Exception('Download is not possible');
    }
  }

  Future<Diary> importDiaryFromFile(FileSystemEntity f, BuildContext ctx) async {
    AppDatabase db = AppDatabase();

    File jsonFile = File(f.path);
    String jsonData = await jsonFile.readAsString();
    Map<String,dynamic> diaryData = jsonDecode(jsonData);
    //print('DIARY DATA IS ${diaryData.}');
    try {
      for (var entry in diaryData['entries']) {
        await db.addDiaryEntry(
          diaryId: diary.id, 
          entry: entry['entry'], 
          diaryEntryDateTime: DateTime.parse(entry['dateCreated'])
        );
      }
      if(ctx.mounted) {
        Navigator.of(ctx).pop();
      }
      //Get the new diary
      Diary newDiary = await db.getDiary(diary);
      return newDiary;
    } catch(err) {
      throw Exception('An error occurred fetching importing the diary');
    }

  }

  showImportFileDialog(BuildContext context, String diaryName, FileSystemEntity f) {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text('Import $diaryName',
          textAlign: TextAlign.center,
          overflow: TextOverflow.clip,
          style: const TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        content: SizedBox(
          width: 300,
          height: 100,
          child: Column(
            children: [
              Text(
                'Are you sure you want to import $diaryName?', textAlign: TextAlign.center
              ),
              const SizedBox(height: 10,),
              const Text('This will mege the data from the selected file into this diary.', textAlign: TextAlign.center,)
            ],
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
              onPressed: () async { 
                Diary newDiary = await importDiaryFromFile(f,context);
                onAfterImport(newDiary, DateTime.now());
                if(context.mounted) {
                  Navigator.of(context).pop();
                }
              }, 
              child: const Text('Yes')
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: const Text('No')
            )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContainerDialog(
      title: const Text(
        "My Diaries", 
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold
        ),
      ), 
      content: FutureBuilder<List<Widget>>(
        future: getFileList(context), 
        builder: (ctx,sn) => sn.connectionState == ConnectionState.waiting
          ? const SizedBox(
              width: 300,
              height: 300,
              child: LoadingWidget()
          )
          : sn.data!.isEmpty
            ? const SizedBox(
              width: 300,
              height: 50,
              child: Text(
                'There are no files',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
            )
            : SizedBox(
              width: 300,
              height: 300,
              //color: Colors.amber,
              child: SingleChildScrollView(
                child: Column(
                  children: sn.data!
                ),
              )
            )
      ), 
      cancelName: "Close",
    );
  }
}