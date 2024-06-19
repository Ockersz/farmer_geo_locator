import 'package:hive/hive.dart';

import 'farmer_details.dart';

class FarmerRepository {
  static const String _boxName = 'farmerBox';

  Future<void> init() async {
    await Hive.openBox<FarmerDetails>(_boxName);
  }

  Future<List<FarmerDetails>> getFarmers() async {
    var box = Hive.box<FarmerDetails>(_boxName);
    return box.values.toList();
  }

  Future<FarmerDetails> getFarmer(String id) async {
    var box = Hive.box<FarmerDetails>(_boxName);
    return box.values.firstWhere((farmer) => farmer.id == id);
  }

  Future<void> addFarmer(FarmerDetails farmer) async {
    var box = Hive.box<FarmerDetails>(_boxName);
    await box.put(farmer.id, farmer);
  }

  Future<void> updateFarmer(FarmerDetails farmer) async {
    var box = Hive.box<FarmerDetails>(_boxName);
    await box.put(farmer.id, farmer);
  }

  Future<void> deleteFarmer(String id) async {
    var box = Hive.box<FarmerDetails>(_boxName);
    await box.delete(id);
  }
}
