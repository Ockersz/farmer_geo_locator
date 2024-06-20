import 'package:hive/hive.dart';

part 'farmer_details.g.dart';

@HiveType(typeId: 0)
class FarmerDetails {
  @HiveField(0)
  late int farmerId;
  @HiveField(1)
  late String fieldCode;
  @HiveField(2)
  late String farmerName;
  @HiveField(3)
  late String fieldName;
  @HiveField(4)
  late String hectares;
  @HiveField(5)
  late String noOfTrees;
  @HiveField(6)
  late double latitude;
  @HiveField(7)
  late double longitude;
  @HiveField(8)
  late String groupName;
  @HiveField(9)
  late String supplierName;

  FarmerDetails({
    required this.farmerId,
    required this.fieldCode,
    required this.farmerName,
    required this.fieldName,
    required this.hectares,
    required this.noOfTrees,
    required this.latitude,
    required this.longitude,
    required this.groupName,
    required this.supplierName,
  });

  Map<String, dynamic> toJson() {
    return {
      'farmerId': farmerId,
      'fieldCode': fieldCode,
      'farmerName': farmerName,
      'fieldName': fieldName,
      'hectares': hectares,
      'noOfTrees': noOfTrees,
      'latitude': latitude,
      'longitude': longitude,
      'groupName': groupName,
      'supplierName': supplierName,
    };
  }

  factory FarmerDetails.fromJson(Map<String, dynamic> json) {
    return FarmerDetails(
      farmerId: json['farmerId'],
      fieldCode: json['fieldCode'],
      farmerName: json['farmerName'],
      fieldName: json['fieldName'],
      hectares: json['hectares'],
      noOfTrees: json['noOfTrees'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      groupName: json['groupName'],
      supplierName: json['supplierName'],
    );
  }
}
