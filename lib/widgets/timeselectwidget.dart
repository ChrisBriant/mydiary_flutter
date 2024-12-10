import 'dart:math';

import 'package:flutter/material.dart';

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
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            children: [
              InkWell(
                onTap: () {
                  int nextStep = hour!;
                  if(hour! + 1 > 23) {
                    nextStep = 0;
                  } else {
                    nextStep++;
                  }
          
                  setState(() {
                    hour = nextStep;
                  });
                  //Call update
                  widget.onUpdate(hour,minute);
                },
                child: Container(
                  color: Colors.grey,
                  child: const Icon(Icons.arrow_upward, size: 18,)
                ),
              ),
              Container(
                color: Colors.white,
                child: Text(
                  hour.toString().padLeft(2,'0'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize : 20,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  int prevStep = hour!;
                  if(hour! - 1 < 0) {
                    prevStep = 23;
                  } else {
                    prevStep--;
                  }
          
                  setState(() {
                    hour = prevStep;
                  });
                  //Call update
                  widget.onUpdate(hour,minute);
                },
                child: Container(
                  color: Colors.grey,
                  child: const Icon(Icons.arrow_downward, size: 18,)
                ),
              ),
            ],
          ),
          const Text(":",
              style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize : 20,
            ),
          ),
          Column(
            children: [
              InkWell(
                onTap: () {
                  int nextStep = minute!;
                  if(minute! + 1 > 59) {
                    nextStep = 0;
                  } else {
                    nextStep++;
                  }
          
                  setState(() {
                    minute = nextStep;
                  });
                  //Call update
                  widget.onUpdate(hour,minute);
                },
                child: Container(
                  color: Colors.grey,
                  child: const Icon(Icons.arrow_upward, size: 18,)
                ),
              ),
              Container(
                color: Colors.white,
                child: Text(
                  minute.toString().padLeft(2,'0'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize : 20,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  int prevStep = minute!;
                  if(minute! - 1 < 0) {
                    prevStep = 59;
                  } else {
                    prevStep--;
                  }
          
                  setState(() {
                    minute = prevStep;
                  });
                  //Call update
                  widget.onUpdate(hour,minute);
                },
                child: Container(
                  color: Colors.grey,
                  child: const Icon(Icons.arrow_downward, size: 18,)
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}