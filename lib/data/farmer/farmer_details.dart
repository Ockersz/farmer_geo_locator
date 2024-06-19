import 'package:hive/hive.dart';

part 'farmer_details.g.dart';

@HiveType(typeId: 0)
class FarmerDetails {
  @HiveField(0)
  late String name;
  @HiveField(1)
  late String id;
  @HiveField(2)
  late String nic;
  @HiveField(3)
  late String csCode;
  @HiveField(4)
  late double latitude;
  @HiveField(5)
  late double longitude;

  FarmerDetails({
    required this.name,
    required this.id,
    required this.nic,
    required this.csCode,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'nic': nic,
      'csCode': csCode,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory FarmerDetails.fromJson(Map<String, dynamic> json) {
    return FarmerDetails(
      name: json['name'],
      id: json['id'],
      nic: json['nic'],
      csCode: json['csCode'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
