import 'dart:async';

import 'package:farmer_geo_locator/data/farmer/farmer_details.dart';
import 'package:farmer_geo_locator/data/farmer/farmer_service.dart';
import 'package:farmer_geo_locator/src/custom_alert/custom_alert.dart';
import 'package:farmer_geo_locator/src/locator_home.dart/farmer_view.dart';
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
  String farmerName = '';
  String fieldName = '';
  double farmerLongitude = 0.0;
  double farmerLatitude = 0.0;
  int farmerId = 0;
  FarmerDetails farmer = FarmerDetails(
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
                  onEditingComplete: _getFarmerDetails,
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
                const SizedBox(height: 20),
                farmerId != 0
                    ? FarmerView(
                        farmerName: farmerName,
                        fieldName: fieldName,
                        longitude: longitude,
                        latitude: latitude)
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getFarmerDetails() async {
    setState(() {
      farmerId = 0;
      farmerName = '';
      fieldName = '';
      farmerLongitude = 0.0;
      farmerLatitude = 0.0;
    });

    if (_supplierIdController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomAlert(
            title: 'Warning !',
            message: 'Please enter field code.',
            icon: Icons.warning_amber_outlined,
            iconColor: Colors.amber,
          );
        },
      );
      return;
    }
    try {
      FarmerService farmerService = FarmerService();
      final farmer =
          await farmerService.getFarmerByField(_supplierIdController.text);
      if (farmer.farmerId == 0) {
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlert(
              title: 'Warning !',
              message: 'Farmer not found.',
              icon: Icons.warning_amber_outlined,
              iconColor: Colors.amber,
            );
          },
        );
        return;
      }
      this.farmer = farmer;
      setState(() {
        farmerId = farmer.farmerId;
        farmerName = farmer.farmerName;
        fieldName = farmer.fieldName;
        farmerLongitude = farmer.longitude;
        farmerLatitude = farmer.latitude;
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomAlert(
            title: 'Error !',
            message: e.toString(),
            icon: Icons.error,
          );
        },
      );
    }
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
          showDialog(
            context: context,
            builder: (context) {
              return CustomAlert(
                title: 'Warning !',
                message:
                    'Location services are disabled. Please enable them in your settings.',
                icon: Icons.warning_amber_outlined,
                iconColor: Colors.amber,
              );
            },
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlert(
              title: 'Warning !',
              message:
                  'Location services are disabled. Please enable them in your settings.',
              icon: Icons.warning_amber_outlined,
              iconColor: Colors.amber,
            );
          },
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
          showDialog(
            context: context,
            builder: (context) {
              return CustomAlert(
                title: 'Error !',
                message: 'Location permissions are denied.',
                icon: Icons.error,
              );
            },
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }

      if (permissionGranted == LocationPermission.deniedForever) {
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlert(
              title: 'Error !',
              message: 'Location permissions are permanently denied.',
              icon: Icons.error,
            );
          },
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

      _completer!.complete();
    } catch (e) {
      if (!_completer!.isCompleted) {
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlert(
              title: 'Error !',
              message: e.toString(),
              icon: Icons.error,
            );
          },
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
      showDialog(
        context: context,
        builder: (context) {
          return CustomAlert(
            title: 'Warning !',
            message: 'Please get location first.',
            icon: Icons.warning_amber_outlined,
            iconColor: Colors.amber,
          );
        },
      );
      return false;
    }

    if (_supplierIdController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomAlert(
            title: 'Warning !',
            message: 'Please enter field code',
            icon: Icons.warning_amber_outlined,
            iconColor: Colors.amber,
          );
        },
      );
      return false;
    }

    FarmerService farmerService = FarmerService();
    if (farmerId == 0) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomAlert(
            title: 'Warning !',
            message: 'Please get farmer details first.',
            icon: Icons.warning_amber_outlined,
            iconColor: Colors.amber,
          );
        },
      );
      return false;
    }

    farmer.latitude = latitude;
    farmer.longitude = longitude;

    await farmerService.updateFarmer(farmer);

    showDialog(
      context: context,
      builder: (context) {
        return CustomAlert(
          title: 'Success !',
          message: 'Location saved successfully.',
          icon: Icons.warning_amber_outlined,
          iconColor: Colors.green,
        );
      },
    );

    setState(() {
      _supplierIdController.clear();
      latitude = 0.0;
      longitude = 0.0;
      farmer = FarmerDetails(
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
      farmerId = 0;
      farmerName = '';
      fieldName = '';
      farmerLongitude = 0.0;
      farmerLatitude = 0.0;
    });

    return true;
  }
}
