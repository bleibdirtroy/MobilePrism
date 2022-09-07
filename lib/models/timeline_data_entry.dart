import 'package:mobileprism/models/photo_data_entry.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class TimelineDataEntry {
  int id;
  @Unique()
  final String uid;
  final int year;
  final int month;
  @Backlink('timlineAlbum')
  final timelinePhotos = ToMany<PhotoDataEntry>();

  TimelineDataEntry({
    this.id = 0,
    required this.uid,
    required this.year,
    required this.month,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is TimelineDataEntry
        && other.uid == uid
        && other.year == year
        && other.month == month;
  }

  @override
  int get hashCode => Object.hash(uid, year, month);

}
