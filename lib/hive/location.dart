import 'package:hive/hive.dart';

part 'location.g.dart';

@HiveType(typeId: 1)
class Location {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  double latitude;
  @HiveField(3)
  double longitude;
  @HiveField(4)
  double altitude;
  @HiveField(5)
  String address;
  @HiveField(6)
  String what3words;
  @HiveField(7)
  DateTime timeStamp;
  @HiveField(8)
  DateTime appointment;
  @HiveField(9)
  String notes;

Location({required this.id,
  required this.name,
  required this.latitude,
  required this.longitude,
  required this.altitude,
  required this.address,
  required this.what3words,
  required this.timeStamp,
  required this.appointment,
  required this.notes});

}