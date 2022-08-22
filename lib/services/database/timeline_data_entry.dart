class TimelineDataEntry {
  late final String uid;
  late final int year;
  late final int month;

  TimelineDataEntry({
    required this.uid,
    required this.year,
    required this.month,
  });

  TimelineDataEntry.fromDbEntry(Map<String, dynamic> data) {
    uid = data["uid"] as String;
    year = data["year"] as int;
    year = data["month"] as int;
  }

  Map<String, dynamic> toDbEntry() => {
        "uid": uid,
        "year": year,
        "month": month,
      };
}
