import 'package:farmer_geo_locator/data/farmer/farmer_details.dart';
import 'package:farmer_geo_locator/data/farmer/farmer_service.dart';
import 'package:farmer_geo_locator/data/farmer/farmer_tile.dart';
import 'package:farmer_geo_locator/data/user/user_details.dart';
import 'package:farmer_geo_locator/data/user/user_service.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  static const routeName = '/settings';

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final double buttonWidth = 250.0;
  final TextEditingController _officerNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              SizedBox(
                width: buttonWidth,
                child: ElevatedButton.icon(
                  onPressed: () {
                    print('Clear Data');
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Clear Data'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[200],
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: buttonWidth,
                child: ElevatedButton.icon(
                  onPressed: () {
                    print('Sync Data');
                  },
                  icon: const Icon(Icons.sync),
                  label: const Text('Sync Data To Company'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: buttonWidth,
                child: ElevatedButton.icon(
                  onPressed: _viewFarmerData,
                  icon: const Icon(Icons.remove_red_eye),
                  label: const Text('View Saved Data'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: buttonWidth,
                child: ElevatedButton.icon(
                  onPressed: _downloadData,
                  icon: const Icon(Icons.download_sharp),
                  label: const Text('Download Farmers'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Column(
                children: [
                  const Text('Officer Name: '),
                  TextField(
                    controller: _officerNameController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'Officer Name',
                    ),
                    keyboardType: TextInputType.name,
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: buttonWidth,
                child: ElevatedButton.icon(
                  onPressed: _saveUser,
                  icon: const Icon(Icons.man_2_outlined),
                  label: const Text('Save Officer Name'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amberAccent,
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'Version 1.0.0',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveUser() async {
    try {
      String officerName = _officerNameController.text;
      if (officerName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter the officer name'),
          ),
        );
        return;
      }

      UserService userService = UserService();
      UserDetails user = UserDetails(username: officerName);
      await userService.updateUser(user);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Officer name saved successfully'),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  void _downloadData() async {
    bool isConnectionAvailable =
        await InternetConnectionChecker().hasConnection;

    if (!isConnectionAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No internet connection available'),
        ),
      );
      return;
    }

    FarmerService farmerService = FarmerService();
    var farmers = await farmerService.retrieveFarmersDatabase();
    if (farmers) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Farmers data downloaded successfully'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to download farmers data'),
        ),
      );
    }
  }

  void _viewFarmerData() async {
    FarmerService farmerService = FarmerService();
    var farmers = await farmerService.getFarmers();
    TextEditingController searchController = TextEditingController();
    List<FarmerDetails> filteredFarmers = farmers;

    // Display the farmers in a dialog
    showDialog(
      context: context,
      useSafeArea: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Farmer Locations'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      icon: const Icon(Icons.search),
                      border: UnderlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        filteredFarmers = farmers.where((farmer) {
                          return farmer.farmerName
                                  .toLowerCase()
                                  .contains(value.toLowerCase()) ||
                              farmer.fieldCode
                                  .toLowerCase()
                                  .contains(value.toLowerCase());
                        }).toList();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: filteredFarmers.map((farmer) {
                          return FarmerTile(
                            farmer: farmer,
                            onDelete: () async {
                              bool confirmDelete = await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Confirmation'),
                                      content: const Text(
                                          'Are you sure you want to delete this farmer?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text('No'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: const Text('Yes'),
                                        ),
                                      ],
                                    ),
                                  ) ??
                                  false;
                              if (confirmDelete == true) {
                                await farmerService
                                    .deleteFarmer(farmer.farmerId);
                                Navigator.pop(context);
                                _viewFarmerData();
                              }
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
