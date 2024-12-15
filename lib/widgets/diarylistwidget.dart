import 'package:flutter/material.dart';
import './containerdialog.dart';
import '../data/database.dart';
import '../helpers/helpers.dart';
import '../widgets/loadingwidget.dart';

class DiaryListWidget extends StatelessWidget {
  const DiaryListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    AppDatabase db = AppDatabase();

    return ContainerDialog(
      title: const Text("My Diaries", textAlign: TextAlign.center), 
      content: FutureBuilder<List<Diary>>(
        future: db.getDiaries(), 
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
                'You have no Diaries',
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
              child: ListView.builder(
                //shrinkWrap: true,
                itemCount: sn.data!.length,
                itemBuilder: (ctx, idx) => InkWell(
                  onLongPress: () => Navigator.of(ctx).popAndPushNamed('/diaryscreen',arguments: {
                    'diary' : sn.data![idx]
                  }),
                  child: ListTile(
                    key: ValueKey(sn.data![idx].id),
                    title: Text(
                      sn.data![idx].name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.brown, 
                        fontSize: 20.0,
                      ),
                    ),
                    subtitle: Text(
                      Helpers.getDisplayDate(sn.data![idx].dateCreated),
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.blue, 
                        fontSize: 16.0,
                      ),
                    ),
                    dense: true,
                    // titleTextStyle: const TextStyle(
                    //   fontWeight: FontWeight.bold,
                    //   color: Colors.brown, 
                    //   fontSize: 30.0,
                    // ),
                  ),
                ),
              ),
            )
      ), 
      // confirmAction: () => Navigator.of(context).pop(), 
      // confirmName: "Close"
      cancelName: "Close",
    );
  }
}