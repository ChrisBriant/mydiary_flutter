import 'package:flutter/material.dart';
import '../widgets/creatediarywidget.dart';
import '../widgets/diarylistwidget.dart';

class Home extends StatelessWidget {
  static const String routeName = "/homescreen";
  static const String aboutText = "This is your personal sanctuary for reflection and growth. Create a unique digital diary tailored to your style, where you can freely express yourself through words and images.";

  const Home({super.key});

  @override
  Widget build(BuildContext context) {

    void showAddDiaryDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const CreateDiaryWidget();
        },
      );
    }

    void showDiaryListDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const DiaryListWidget();
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('My Diary'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/diary_banner_image.png'),
            const SizedBox(height: 10,),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: const Card(
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    aboutText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () => showDiaryListDialog(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade200,
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
                    padding: const EdgeInsets.all(4),
                    width: MediaQuery.of(context).size.width * .4,
                    height: MediaQuery.of(context).size.width * .4,
                    child: Column(
                      children: [
                        const Text(
                          'Open Diary',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Image.asset(
                          'assets/open_diary_3.png',
                          width: MediaQuery.of(context).size.width * .3,
                          height: MediaQuery.of(context).size.width * .3,
                        ),
                      ],
                    )
                  ),
                ),
                InkWell(
                  onTap: () => showAddDiaryDialog(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade200,
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
                    padding: const EdgeInsets.all(4),
                    width: MediaQuery.of(context).size.width * .4,
                    height: MediaQuery.of(context).size.width * .4,
                    child: Column(
                      children: [
                        const Text(
                          'Create Diary',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Image.asset(
                          'assets/create_diary_3.png',
                          width: MediaQuery.of(context).size.width * .3,
                          height: MediaQuery.of(context).size.width * .3,
                        ),
                      ],
                    )
                  ),
                ),
              ],
            )
            // ElevatedButton(
            //   onPressed: () => showDiaryListDialog(), 
            //   child: const Text('Open Diary')
            // ),
            // ElevatedButton(
            //   onPressed: () => showAddDiaryDialog(), 
            //   child: const Text('Create Diary')
            // ),
        
          ]
          
        ),
      ),
    );
  }
}