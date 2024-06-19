import 'package:farmer_geo_locator/data/farmer/farmer_details.dart';
import 'package:farmer_geo_locator/data/farmer/farmer_service.dart';
import 'package:farmer_geo_locator/data/farmer/farmer_tile.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  static const routeName = '/settings';

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final double buttonWidth = 250.0;

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
            ],
          ),
        ),
      ),
    );
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
                        border: UnderlineInputBorder()),
                    onChanged: (value) {
                      setState(() {
                        filteredFarmers = farmers.where((farmer) {
                          return farmer.name
                                  .toLowerCase()
                                  .contains(value.toLowerCase()) ||
                              farmer.id
                                  .toLowerCase()
                                  .contains(value.toLowerCase()) ||
                              farmer.csCode
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
                                      title: Text('Confirmation'),
                                      content: Text(
                                          'Are you sure you want to delete this farmer?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: Text('No'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: Text('Yes'),
                                        ),
                                      ],
                                    ),
                                  ) ??
                                  false;
                              if (confirmDelete == true) {
                                await farmerService.deleteFarmer(farmer.id);
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
