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
          const Text(" : ",
              style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize : 20,
            ),
          ),
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