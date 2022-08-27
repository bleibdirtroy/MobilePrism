class TimelineDataEntry {
  final String uid;
  final int year;
  final int month;

  TimelineDataEntry({
    required this.uid,
    required this.year,
    required this.month,
  });

  TimelineDataEntry.fromDbEntry(Map<String, dynamic> data)
      : uid = data["uid"] as String,
        year = data["year"] as int,
        month = data["month"] as int;

  Map<String, dynamic> toDbEntry() => {
        "uid": uid,
        "year": year,
        "month": month,
      };

  TimelineDataEntry.fromJson(Map<String, dynamic> json)
      : uid = json["UID"] as String,
        year = json["Year"] as int,
        month = json["Month"] as int;
}
