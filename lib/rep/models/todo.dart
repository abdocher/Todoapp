class Todo {
  final String title;
  final String date;
  final String time;
  final int id;
  final String categoryName;
  int isDone;
  Todo(
    this.id,
    this.title,
    this.date,
    this.time,
    this.categoryName,
    this.isDone,
  );
  bool isOutOfDate() {
    DateTime date = DateTime.parse(this.date + ' ' + time);
    return date.isBefore(DateTime.now());
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date,
      'time': time,
      'categoryName': categoryName,
      'isDone': isDone,
    };
  }

  @override
  String toString() {
    return 'Category{title : $title , Category : $categoryName}';
  }
}
