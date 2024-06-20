import 'package:farmer_geo_locator/data/farmer/farmer_details.dart';
import 'package:farmer_geo_locator/data/farmer/farmer_service.dart';
import 'package:farmer_geo_locator/data/farmer/farmer_tile.dart';
import 'package:farmer_geo_locator/src/custom_alert/custom_alert.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  static const routeName = '/settings';

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final double buttonWidth = 250.0;
  final TextEditingController _officerNameController = TextEditingController();
  var isDownloading = false;
  bool isSyncing = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // SizedBox(
                          //   width: buttonWidth,
                          //   child: ElevatedButton.icon(
                          //     onPressed: () {
                          //       print('Clear Data');
                          //     },
                          //     icon: const Icon(Icons.delete),
                          //     label: const Text('Clear Data'),
                          //     style: ElevatedButton.styleFrom(
                          //       backgroundColor: Colors.blueGrey[200],
                          //       foregroundColor: Colors.black,
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: buttonWidth,
                            child: ElevatedButton.icon(
                              onPressed: isSyncing ? null : _syncData,
                              icon: const Icon(Icons.sync),
                              label: const Text('Sync Data To Company'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[300],
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
                                backgroundColor: Colors.blue[300],
                                foregroundColor: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: buttonWidth,
                            child: ElevatedButton.icon(
                              onPressed: isDownloading ? null : _downloadData,
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
                                backgroundColor: Colors.amberAccent[200],
                                foregroundColor: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'Version 1.0.0',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? officerName = prefs.getString('officerName');
    if (officerName != null) {
      _officerNameController.text = officerName;
    }
  }

  void _saveUser() async {
    try {
      String officerName = _officerNameController.text;
      if (officerName.isEmpty) {
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlert(
              title: 'Warning !',
              message: 'Please enter the officer name',
              icon: Icons.warning_amber_outlined,
            );
          },
        );
        return;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('officerName', officerName);

      showDialog(
        context: context,
        builder: (context) {
          return CustomAlert(
            title: 'Success !',
            message: 'Officer name saved successfully',
            icon: Icons.check_circle_outline,
            iconColor: Colors.green,
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  void _downloadData() async {
    setState(() {
      isDownloading = true;
    });
    bool isConnectionAvailable =
        await InternetConnectionChecker().hasConnection;

    if (!isConnectionAvailable) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomAlert(
            title: 'Denied !',
            message: 'No internet connection available',
            icon: Icons.stop_circle_outlined,
            iconColor: Colors.red,
          );
        },
      );
      setState(() {
        isDownloading = false;
      });
      return;
    }

    FarmerService farmerService = FarmerService();
    bool success = await farmerService.retrieveFarmersDatabase();
    if (success) {
      setState(() {
        isDownloading = false;
      });
      showDialog(
        context: context,
        builder: (context) {
          return CustomAlert(
            title: 'Success !',
            message: 'Farmers data downloaded successfully',
            icon: Icons.check_circle_outline,
            iconColor: Colors.green,
          );
        },
      );
    } else {
      setState(() {
        isDownloading = false;
      });
      showDialog(
        context: context,
        builder: (context) {
          return CustomAlert(
            title: 'Sorry !',
            message: 'Failed to download farmers data',
            icon: Icons.fmd_bad_outlined,
            iconColor: Colors.red,
          );
        },
      );
    }
  }

  void _viewFarmerData() async {
    FarmerService farmerService = FarmerService();
    List<FarmerDetails> farmers = await farmerService.getFarmers();
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
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      icon: Icon(Icons.search),
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

  void _syncData() async {
    setState(() {
      isSyncing = true;
    });

    bool isConnectionAvailable =
        await InternetConnectionChecker().hasConnection;

    if (!isConnectionAvailable) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomAlert(
            title: 'Denied !',
            message: 'No internet connection available',
            icon: Icons.stop_circle_outlined,
            iconColor: Colors.red,
          );
        },
      );
      setState(() {
        isSyncing = false;
      });
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    const String officerNameKey = 'officerName';
    String? officerName = prefs.getString(officerNameKey);
    if (officerName == null) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomAlert(
            title: 'Warning !',
            message: 'Please save the officer name first',
            icon: Icons.warning_amber_outlined,
          );
        },
      );
      setState(() {
        isSyncing = false;
      });
      return;
    }

    try {
      FarmerService farmerService = FarmerService();
      var farmers = await farmerService.getFarmers();
      if (farmers.isEmpty) {
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlert(
              title: 'Warning !',
              message: 'No farmers data available to sync',
              icon: Icons.warning_amber_outlined,
            );
          },
        );
        setState(() {
          isSyncing = false;
        });
        return;
      }
      bool res = await farmerService.syncFarmers();
      if (res) {
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlert(
              title: 'Success !',
              message: 'Farmers data synced successfully',
              icon: Icons.check_circle_outline,
              iconColor: Colors.green,
            );
          },
        );
        setState(() {
          isSyncing = false;
        });
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlert(
              title: 'Sorry !',
              message: 'Failed to sync farmers data',
              icon: Icons.fmd_bad_outlined,
              iconColor: Colors.red,
            );
          },
        );
        setState(() {
          isSyncing = false;
        });
      }
    } catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) {
          return CustomAlert(
            title: 'Error !',
            message: 'An error occurred while syncing farmers data',
            icon: Icons.error_outline,
            iconColor: Colors.red,
          );
        },
      );
      setState(() {
        isSyncing = false;
      });
    }
  }
}
