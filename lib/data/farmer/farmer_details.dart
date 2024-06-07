class FarmerDetails {
  late String name;
  late String id;
  late String nic;
  late String csCode;
  late double latitude;
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

  @override
  String toString() {
    return 'FarmerDetails{name: $name, id: $id, nic: $nic, csCode: $csCode, latitude: $latitude, longitude: $longitude}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FarmerDetails &&
        other.name == name &&
        other.id == id &&
        other.nic == nic &&
        other.csCode == csCode &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        id.hashCode ^
        nic.hashCode ^
        csCode.hashCode ^
        latitude.hashCode ^
        longitude.hashCode;
  }
}
