import 'dart:async';

import 'package:farmer_geo_locator/data/farmer/farmer_details.dart';
import 'package:farmer_geo_locator/data/farmer/farmer_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class LocatorHome extends StatefulWidget {
  const LocatorHome({super.key});

  static const routeName = '/locator_home';

  @override
  _LocatorHomeState createState() => _LocatorHomeState();
}

class _LocatorHomeState extends State<LocatorHome> {
  double latitude = 0.0;
  double longitude = 0.0;
  bool _isLoading = false;
  final TextEditingController _supplierIdController = TextEditingController();
  Completer<void>? _completer;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Supplier Locator'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).pushNamed('/settings');
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Enter Field Code:',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _supplierIdController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Field Code',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 100),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                        onPressed: _getLocation,
                        label: const Text('Get Location'),
                        icon:
                            const Icon(Icons.location_on, color: Colors.white),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[200],
                          foregroundColor: Colors.black,
                        ),
                      ),
                const SizedBox(height: 20),
                _isLoading
                    ? ElevatedButton.icon(
                        onPressed: _cancelLocationFetching,
                        label: const Text('Cancel'),
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[200],
                          foregroundColor: Colors.black,
                        ))
                    : const SizedBox(
                        height: 20,
                      ),
                if (latitude != 0.0 || longitude != 0.0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text('Latitude: $latitude',
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 10),
                      Text('Longitude: $longitude',
                          style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                const SizedBox(height: 50),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[200],
                    foregroundColor: Colors.black,
                  ),
                  onPressed: saveFarmerDetails,
                  icon: Icon(Icons.save),
                  label: Text('Save Location'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getLocation() async {
    setState(() {
      _isLoading = true;
      longitude = 0.0;
      latitude = 0.0;
    });
    LocationAccuracy accuracy = LocationAccuracy.high;
    _completer = Completer<void>();

    try {
      bool isConnectionAvailable =
          await InternetConnectionChecker().hasConnection;

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        accuracy = LocationAccuracy.low;
        bool locSettings = await Geolocator.openLocationSettings();
        if (!locSettings) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Location services are disabled. Please enable them in your settings.'),
            ),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Location services are disabled. Please enable them in your settings.'),
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      LocationPermission permissionGranted = await Geolocator.checkPermission();
      if (permissionGranted == LocationPermission.denied) {
        permissionGranted = await Geolocator.requestPermission();
        if (permissionGranted == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Location permissions are denied.'),
            ),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }

      if (permissionGranted == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Location permissions are permanently denied. We cannot request permissions.'),
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      if (!isConnectionAvailable) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'You are offline. Getting location might take a few seconds.'),
          ),
        );
      }

      Position position =
          await Geolocator.getCurrentPosition(desiredAccuracy: accuracy);
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Latitude: $latitude, Longitude: $longitude'),
        ),
      );

      _completer!.complete();
    } catch (e) {
      if (!_completer!.isCompleted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _cancelLocationFetching() {
    _completer?.complete();
    setState(() {
      _isLoading = false;
    });
  }

  Future<bool> saveFarmerDetails() async {
    if (latitude == 0.0 || longitude == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please get location first.'),
        ),
      );
      return false;
    }

    if (_supplierIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter field code.'),
        ),
      );
      return false;
    }

    //Check if supplier already exists
    List<FarmerDetails> farmers = await FarmerService().getFarmers();
    if (farmers.any((farmer) => farmer.id == _supplierIdController.text)) {
      await FarmerService()
          .updateFarmer(
        FarmerDetails(
          id: _supplierIdController.text,
          name: 'Farmer',
          nic: '123456789V',
          csCode: 'CS123',
          latitude: latitude,
          longitude: longitude,
        ),
      )
          .then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location updated successfully.'),
          ),
        );
        return true;
      }).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
          ),
        );
        return Future.value(null);
      });
    }

    FarmerDetails farmer = FarmerDetails(
      id: _supplierIdController.text,
      name: 'Farmer',
      nic: '123456789V',
      csCode: 'CS123',
      latitude: latitude,
      longitude: longitude,
    );

    await FarmerService().addFarmer(farmer).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location saved successfully.'),
        ),
      );
      return true;
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
        ),
      );
      return Future.value(null);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Location saved successfully.'),
      ),
    );

    setState(() {
      _supplierIdController.clear();
      latitude = 0.0;
      longitude = 0.0;
    });

    return true;
  }
}
