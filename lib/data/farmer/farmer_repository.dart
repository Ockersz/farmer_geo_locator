import 'dart:async';
import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'farmer_details.dart';

class FarmerRepository {
  static const String _boxName = 'farmerBox';
  static const String _boxListName = 'farmerList';
  final String baseURL = "https://api.hexagonasia.com";
  static const Duration timeoutDuration = Duration(seconds: 20);
  static const Duration syncDuration = Duration(seconds: 1);

  Future<void> init() async {
    await Hive.openBox<FarmerDetails>(_boxName);
    await Hive.openBox<FarmerDetails>(_boxListName);
  }

  Future<List<FarmerDetails>> getFarmers() async {
    var box = Hive.box<FarmerDetails>(_boxName);
    return box.values.toList();
  }

  Future<FarmerDetails> getFarmer(String id) async {
    var box = Hive.box<FarmerDetails>(_boxName);
    return box.values.firstWhere((farmer) => farmer.farmerId == id);
  }

  Future<void> addFarmer(FarmerDetails farmer) async {
    var box = Hive.box<FarmerDetails>(_boxName);
    await box.put(farmer.farmerId, farmer);
  }

  Future<void> updateFarmer(FarmerDetails farmer) async {
    var box = Hive.box<FarmerDetails>(_boxName);
    await box.put(farmer.farmerId, farmer);
  }

  Future<void> deleteFarmer(int id) async {
    var box = Hive.box<FarmerDetails>(_boxName);
    await box.delete(id);
  }

  Future<bool> retrieveFarmersDatabase() async {
    try {
      final response = await http
          .get(Uri.http(baseURL, '/fielddetails/get/farmers'))
          .timeout(timeoutDuration, onTimeout: () {
        print('Request to the server timed out.');
        throw TimeoutException(
            'The connection has timed out, please try again later.');
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data != null && data is List) {
          var box = await Hive.openBox<FarmerDetails>(_boxListName);
          await box.clear();

          for (var item in data) {
            try {
              final farmerDetails = FarmerDetails(
                farmerId: int.tryParse(item['farmerId'].toString()) ?? 0,
                fieldCode: item['fieldCode'].toString(),
                farmerName: item['farmerName'].toString(),
                fieldName: item['fieldName'].toString(),
                hectares: item['hectares'].toString(),
                noOfTrees: item['noOfTrees'].toString(),
                latitude: double.tryParse(item['latitude'].toString()) ?? 0.0,
                longitude: double.tryParse(item['longitude'].toString()) ?? 0.0,
                groupName: item['groupName'].toString(),
                supplierName: item['supplierName'].toString(),
              );
              await box.put(farmerDetails.farmerId, farmerDetails);
            } catch (e) {
              print('Error parsing item: $item, error: $e');
              return false;
            }
          }
          return true;
        } else {
          return false;
        }
      } else {
        print('Failed to load farmers data: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error retrieving farmers data: $e');
      return false;
    }
  }

  Future<FarmerDetails> getFarmerByField(String fieldCode) async {
    try {
      var box = Hive.box<FarmerDetails>(_boxListName);
      return box.values.firstWhere((farmer) =>
          farmer.fieldCode.toLowerCase() == fieldCode.toLowerCase());
    } catch (e) {
      print('Error getting farmer by field code: $e');
      return FarmerDetails(
        farmerId: 0,
        fieldCode: '',
        farmerName: '',
        fieldName: '',
        hectares: '',
        noOfTrees: '',
        latitude: 0.0,
        longitude: 0.0,
        groupName: '',
        supplierName: '',
      );
    }
  }

  Future<void> clearFarmers() async {
    var box = await Hive.openBox<FarmerDetails>(_boxName);
    await box.clear();
  }

  Future<bool> syncFarmersToDatabase() async {
    try {
      final box = Hive.box<FarmerDetails>(_boxName);
      final farmers = box.values.toList();
      final prefs = await SharedPreferences.getInstance();
      final user = prefs.getString('officerName');
      List<Map<String, dynamic>> body = [];

      for (final farmer in farmers) {
        body.add(farmer.toJson());
      }

      final uri = Uri.http(baseURL, '/fielddetails/update');
      final response = await http
          .put(
            uri,
            headers: {
              'Content-Type':
                  'application/json', // Ensure content type is set to JSON
            },
            body: jsonEncode({
              'rows': body,
              'user': user,
            }),
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        print('Farmers synced successfully');
        await clearFarmers();
        return true;
      } else {
        print('Failed to sync farmers');
        print('Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error syncing farmers to database: $e');
      return false;
    }
  }
}
