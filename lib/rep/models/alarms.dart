class Alarm {
  final String date;
  final String time;
  Alarm(this.date, this.time);
  
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'time': time,
    };
  }
}
