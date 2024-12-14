import 'package:flutter/material.dart';

class CalendarWidget extends StatefulWidget {
  final Map<DateTime,Function>? dateActions;
  final DateTime? selectedDate;

  const CalendarWidget({
    this.dateActions,
    this.selectedDate,
    super.key
  });

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime selectedDate = DateTime.now();

  //Get the date of the first day next month
  DateTime getFirstNextMonth() {
    int nextMonth = 0;
    int nextMonthYear = selectedDate.year;

    //Get the next month
    selectedDate.month + 1 == 13 ? { nextMonth = 1, nextMonthYear += 1 } : nextMonth = selectedDate.month + 1;
    DateTime nextMonthDate = DateTime(nextMonthYear,nextMonth);

    return nextMonthDate;
  }

  DateTime getFirstPrevMonth() {
    int prevMonth = 0;
    int prevMonthYear = selectedDate.year;

    //Get the previous month
    selectedDate.month - 1 == 0 ? { prevMonth = 12, prevMonthYear -= 1 } : prevMonth = selectedDate.month - 1;
    DateTime prevMonthDate = DateTime(prevMonthYear,prevMonth);

    return prevMonthDate;
  }

  String getMonthName(int m) {
    switch (m) {
      case 1:
        return "January";
      case 2:
        return "February";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "August";
      case 9:
        return "September";
      case 10:
        return "October";
      case 11:
        return "November";
      case 12:
        return "December";
      default:
      return "Unknown";
    }
  }

  //Get the previous monday
  getMonday(DateTime date) {
    if(date.weekday == DateTime.monday) {
      return date;
    } else {
      return getMonday(date.subtract(const Duration(days: 1)));
    }
  }

  //Get the previous monday
  getSunday(DateTime date) {
    if(date.weekday == DateTime.sunday) {
      return date;
    } else {
      return getSunday(date.add(const Duration(days: 1)));
    }
  }

  List<List<CalendarDay>> getCalendarDays() {
    DateTime lastOfMonth =  getFirstNextMonth().subtract(const Duration(days: 1));
    DateTime firstMonday = getMonday(DateTime(selectedDate.year,selectedDate.month));
    DateTime lastSunday = getSunday(lastOfMonth);

    //2 fixes daylight saving when march 23
    int numberOfWeeks = (lastSunday.difference(firstMonday).inDays + 2) ~/ 7;

    //Iterate through to generate the calendar day objects
    //Try to resolve daylight savings issue
    DateTime incDate =  DateTime(firstMonday.year,firstMonday.month,firstMonday.day,4);
    List<List<CalendarDay>> weeks = [];

    for(int i=0; i< numberOfWeeks;i++) {
      List<CalendarDay> weekDays = [];

      for(int i=0;i<7;i++) {
        DayState dayState = DayState.disabled;
        
        DateTime today = DateTime.now();

        if( (incDate.day == today.day) && (incDate.month == today.month) && (incDate.year == today.year) ) {
          dayState = DayState.current;
        } else if(incDate.month == selectedDate.month) {
          dayState = DayState.enabled;
        }

        Function? clickAction;

        //Check for action
        if(widget.dateActions != null) {
          
          clickAction = widget.dateActions?[DateTime(incDate.year,incDate.month,incDate.day)];
          if(clickAction != null) {
            print('I SHOULD ADD A FUNCTION');
            dayState = DayState.active;
          } else {
            print("NOT SETTING THE FUNCTION");
          }
          
        }

        onPressOnDate(DateTime dt) {
          print(dt);
        }

        weekDays.add(
          CalendarDay(
            dayNumber: incDate.day, 
            date: incDate,
            dayState: dayState,
            clickAction: clickAction,
          )
        );

        incDate = incDate.add(const Duration(days: 1));
      }
      weeks.add(weekDays);
    }

    return weeks;
  }

  Color getDayColor(DayState dayState) {
    switch (dayState) {
      case DayState.enabled:
        return Colors.blue.shade100;
      case DayState.current:
        return Colors.yellow.shade100;
      case DayState.active:
        return Colors.purple.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  //Get the calendar block for the days
  Column getCalendarBlock() {
    List<List<CalendarDay>> calendarDays =  getCalendarDays();

    List<Row> calendarColumn = [];

    for (List<CalendarDay> week in calendarDays) {
      List<Container> calDays = [];

      for(CalendarDay calDay in week) {
        calDays.add(
          calDay.clickAction != null
          ? Container(
            color: getDayColor(calDay.dayState),
            child: InkWell(
              onLongPress:  () => calDay.clickAction!(calDay.date),
              child: SizedBox(
                width: 40,
                height: 20,
                child: Text(calDay.dayNumber.toString()),
              ),
            ),
          )
          : Container(
            width: 40,
            height: 20,
            color: getDayColor(calDay.dayState),
            child: Text(calDay.dayNumber.toString()),
          )
        );
      }
      calendarColumn.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: calDays,
      ));
    }

    return Column(
      children: calendarColumn,
    );
  }

  @override
  void initState() {
    super.initState();
    print("I AM INIT STATE");
    if(widget.selectedDate != null) {
      selectedDate = widget.selectedDate!;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("I AM BUILDING ${widget.selectedDate} $selectedDate");

    if(widget.selectedDate != selectedDate && widget.selectedDate != null) {
      print('Date is not right');
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
            width: 280,
            height: 30,
            color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    DateTime prevMonthDT = getFirstPrevMonth();

                    setState(() {
                      selectedDate = prevMonthDT;
                    }); 
                  },  
                ),
                Text('${getMonthName(selectedDate.month)} ${selectedDate.year}'),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    DateTime nextMonth = getFirstNextMonth();

                    setState(() {
                      selectedDate = nextMonth;
                    });
                  },  
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 20,
                color: Colors.grey.shade800,
                child: const Text('Mon', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
              ),
              Container(
                width: 40,
                height: 20,
                color: Colors.grey.shade800,
                child: const Text('Tue', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
              ),
              Container(
                width: 40,
                height: 20,
                color: Colors.grey.shade800,
                child: const Text('Wed', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
              ),
              Container(
                width: 40,
                height: 20,
                color: Colors.grey.shade800,
                child: const Text('Thu', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
              ),
              Container(
                width: 40,
                height: 20,
                color: Colors.grey.shade800,
                child: const Text('Fri', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
              ),
              Container(
                width: 40,
                height: 20,
                color: Colors.grey.shade800,
                child: const Text('Sat', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
              ),
              Container(
                width: 40,
                height: 20,
                color: Colors.grey.shade800,
                child: const Text('Sun', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
              ),
            ],
          ),
          getCalendarBlock()
        ],
      ),
    ); 
     
  }
}

//Active means that it has a function
enum DayState {active,current,enabled,disabled}

class CalendarDay {
  final int dayNumber;
  final DateTime date;
  Function? clickAction;
  DayState dayState;


  CalendarDay({
    required this.dayNumber,
    required this.date,
    this.clickAction,
    this.dayState = DayState.disabled,
  });

}