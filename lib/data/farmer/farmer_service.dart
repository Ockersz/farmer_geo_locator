import 'package:farmer_geo_locator/data/farmer/farmer_details.dart';
import 'package:farmer_geo_locator/data/farmer/farmer_repository.dart';

class FarmerService {
  final FarmerRepository _farmerRepository = FarmerRepository();

  Future<List<FarmerDetails>> getFarmers() async {
    return _farmerRepository.getFarmers();
  }

  Future<FarmerDetails> getFarmer(String id) async {
    return _farmerRepository.getFarmer(id);
  }

  Future<void> addFarmer(FarmerDetails farmer) async {
    return _farmerRepository.addFarmer(farmer);
  }

  Future<void> updateFarmer(FarmerDetails farmer) async {
    return _farmerRepository.updateFarmer(farmer);
  }

  Future<void> deleteFarmer(int id) async {
    return _farmerRepository.deleteFarmer(id);
  }

  Future<bool> retrieveFarmersDatabase() async {
    return await _farmerRepository.retrieveFarmersDatabase();
  }

  Future<FarmerDetails> getFarmerByField(String fieldCode) async {
    return _farmerRepository.getFarmerByField(fieldCode);
  }
}
