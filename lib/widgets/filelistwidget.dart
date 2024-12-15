import 'package:flutter/material.dart';
import './containerdialog.dart';
import '../helpers/helpers.dart';
import '../widgets/loadingwidget.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


class FileListWidget extends StatelessWidget {
  const FileListWidget({super.key});

  Future<List<Widget>> getFileList() async {
    final Directory? directory = await getDownloadsDirectory();
    if(directory != null) {
      try {
        List<FileSystemEntity> fileList = await directory.list().toList();
        List filteredFileList = fileList.where((item) => item.path.endsWith(".json")).toList();
        //print('This is the filelist ${filteredFileList}');
        //Transform the files list into a list of widgets which can be used
        List<Widget> savedFiles = [];
        for (FileSystemEntity f in filteredFileList) {
          savedFiles.add(
            InkWell(
                onLongPress: () {},
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
        print("An error occured $err");
        throw Exception('Unable to retrieve files');
      }
    } else {
      throw Exception('Download is not possible');
    }
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
        future: getFileList(), 
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
              child: Column(
                children: sn.data!
              )
            )
      ), 
      cancelName: "Close",
    );
  }
}