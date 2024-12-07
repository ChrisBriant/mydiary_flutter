class Helpers {
    //DATE FUNCTIONS
  /// Get the date weekday
  static String getWeekDayName(DateTime d) {
    switch (d.weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
    }   return 'Noday';
  }

  /// Get the date monthname
  static String getMonthName(DateTime d) {
    switch (d.month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
    }   return 'Nomonth';
  }

  /// Get the date ordinal indicator, for example 'th', 'nd' etc.
  static String getDateOrdinalIndicator(DateTime d) {
    String dayAsString = d.day.toString();
    switch (dayAsString[dayAsString.length - 1]) {
      case '1' : return '${dayAsString}st'; 
      case '2' : return '${dayAsString}nd';
      case '3' : return '${dayAsString}rd';  
      default: return '${dayAsString}th'; 
    }
  }

  /// Gets the date in a form that we want to display in the app
  static String getDisplayDate(DateTime dateToDisplay) {
    DateTime today = DateTime.now();
    int dayDifference = today.difference(dateToDisplay).inDays;
    if(today.day == dateToDisplay.day) {
      return 'Today';
    }
    if(dayDifference > 1) {
      if(dayDifference < 7) {
        //Return the weekday name
        return getWeekDayName(dateToDisplay);
      } else {
        String day = getWeekDayName(dateToDisplay);
        String ordinalIndicator = getDateOrdinalIndicator(dateToDisplay);
        String month = getMonthName(dateToDisplay);
        return '$day $ordinalIndicator $month';
      }
    }
    //Conditon is yesterday
    return 'Yesterday';
  }

  static String getDateDisplaySimple(DateTime date) {
    String d = date.day.toString().padLeft(2,'0');
    String m = date.month.toString().padLeft(2,'0');
    String y = date.year.toString();
    String h = date.hour.toString().padLeft(2,'0');
    String min = date.minute.toString().padLeft(2,'0');

    return "$d/$m/$y $h:$min";
  }
}