import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  static const routeName = '/settings';

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                    onPressed: () {
                      print('Download Supplier Data');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.download_sharp,
                        ),
                        Text('Download Supplier Data'),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey[200],
                        foregroundColor: Colors.black)),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      print('Sync Data To Company');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sync,
                        ),
                        Text('Sync Data To Company'),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.black)),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      print('View Saved Data');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.remove_red_eye,
                        ),
                        Text('View Saved Data'),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.black)),
                const SizedBox(height: 20),
              ],
            ),
          )),
    );
  }
}
