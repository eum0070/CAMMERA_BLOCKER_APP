class Show {
  final String id;
  final String name;
  final String startTime;
  final String endTime;
  final String date;

  Show({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.date,
  });

  factory Show.fromJson(Map<String, dynamic> json) {
    return Show(
      id: json['_id'],
      name: json['name'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      date: json['date'],
    );
  }
}
