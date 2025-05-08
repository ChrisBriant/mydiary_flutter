import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class TimeSelectWidget extends StatefulWidget {
  final Function onUpdate;
  final int hour;
  final int minute;

  const TimeSelectWidget({
    required this.hour,
    required this.minute,
    required this.onUpdate,
    super.key
  });

  @override
  State<TimeSelectWidget> createState() => _TimeSelectWidgetState();
}

class _TimeSelectWidgetState extends State<TimeSelectWidget> {
  int? hour;
  int? minute;

  @override
  void initState() {
    super.initState();
    hour = widget.hour;
    minute = widget.minute;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration:  BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          NumberPicker(
            minValue: 0, 
            maxValue: 23, 
            value: hour!,
            itemHeight: 25,
            itemWidth: 50,
            zeroPad: true,
            infiniteLoop: true,
            textStyle: const TextStyle(
              fontSize: 10
            ),
            selectedTextStyle:const TextStyle(
              fontSize: 14
            ),
            onChanged: (val) { 
              setState(() {
                hour = val;
              });
              widget.onUpdate(hour,minute);
            }
          ),
          // Column(
          //   children: [
          //     InkWell(
          //       onTap: () {
          //         int nextStep = hour!;
          //         if(hour! + 1 > 23) {
          //           nextStep = 0;
          //         } else {
          //           nextStep++;
          //         }
          
          //         setState(() {
          //           hour = nextStep;
          //         });
          //         //Call update
          //         widget.onUpdate(hour,minute);
          //       },
          //       child: Container(
          //         decoration: BoxDecoration(
          //           color: Colors.blue,
          //           borderRadius: BorderRadius.circular(90),
          //         ),
                  
          //         child: const Icon(Icons.arrow_upward, size: 18, color: Colors.white,)
          //       ),
          //     ),
          //     Container(
          //       decoration: BoxDecoration(
          //         color: Colors.orange.shade300,
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //       margin: const EdgeInsets.symmetric(vertical: 2),
          //       padding: const EdgeInsets.all(2),
          //       child: Text(
          //         hour.toString().padLeft(2,'0'),
          //         style: const TextStyle(
          //           fontWeight: FontWeight.bold,
          //           fontSize : 20,
          //         ),
          //       ),
          //     ),
          //     InkWell(
          //       onTap: () {
          //         int prevStep = hour!;
          //         if(hour! - 1 < 0) {
          //           prevStep = 23;
          //         } else {
          //           prevStep--;
          //         }
          
          //         setState(() {
          //           hour = prevStep;
          //         });
          //         //Call update
          //         widget.onUpdate(hour,minute);
          //       },
          //       child: Container(
          //         decoration: BoxDecoration(
          //           color: Colors.blue,
          //           borderRadius: BorderRadius.circular(90),
          //         ),
          //         child: const Icon(Icons.arrow_downward, size: 18,color: Colors.white,)
          //       ),
          //     ),
          //   ],
          // ),
          const Text(" : ",
              style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize : 20,
            ),
          ),
          // Column(
          //   children: [
          //     InkWell(
          //       onTap: () {
          //         int nextStep = minute!;
          //         if(minute! + 1 > 59) {
          //           nextStep = 0;
          //         } else {
          //           nextStep++;
          //         }
          
          //         setState(() {
          //           minute = nextStep;
          //         });
          //         //Call update
          //         widget.onUpdate(hour,minute);
          //       },
          //       child: Container(
          //         decoration: BoxDecoration(
          //           color: Colors.blue,
          //           borderRadius: BorderRadius.circular(90),
          //         ),
          //         child: const Icon(Icons.arrow_upward, size: 18,color: Colors.white,)
          //       ),
          //     ),
          //     Container(
          //        decoration: BoxDecoration(
          //         color: Colors.orange.shade300,
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //       padding: const EdgeInsets.all(2),
          //       margin: const EdgeInsets.symmetric(vertical: 2),
          //       child: Text(
          //         minute.toString().padLeft(2,'0'),
          //         style: const TextStyle(
          //           fontWeight: FontWeight.bold,
          //           fontSize : 20,
          //         ),
          //       ),
          //     ),
          //     InkWell(
          //       onTap: () {
          //         int prevStep = minute!;
          //         if(minute! - 1 < 0) {
          //           prevStep = 59;
          //         } else {
          //           prevStep--;
          //         }
          
          //         setState(() {
          //           minute = prevStep;
          //         });
          //         //Call update
          //         widget.onUpdate(hour,minute);
          //       },
          //       child: Container(
          //         decoration: BoxDecoration(
          //           color: Colors.blue,
          //           borderRadius: BorderRadius.circular(90),
          //         ),
          //         child: const Icon(Icons.arrow_downward, size: 18,color: Colors.white,)
          //       ),
          //     ),
          //   ],
          // ),
          NumberPicker(
            minValue: 0, 
            maxValue: 23, 
            value: minute!,
            itemHeight: 25,
            itemWidth: 50,
            zeroPad: true,
            infiniteLoop: true,
            textStyle: const TextStyle(
              fontSize: 10
            ),
            selectedTextStyle:const TextStyle(
              fontSize: 14
            ),
            onChanged: (val) { 
              setState(() {
                minute = val;
              });
              widget.onUpdate(hour,minute);
            }
          ),
        ],
      ),
    );
  }
}