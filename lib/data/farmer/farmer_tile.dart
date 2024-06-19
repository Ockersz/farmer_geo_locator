import 'package:farmer_geo_locator/data/farmer/farmer_details.dart';
import 'package:flutter/material.dart';

class FarmerTile extends StatelessWidget {
  final FarmerDetails farmer;
  final VoidCallback onDelete;

  const FarmerTile({
    Key? key,
    required this.farmer,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('${farmer.name}'),
              subtitle: Text('ID: ${farmer.id}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            ),
            const SizedBox(height: 10),
            Text('NIC: ${farmer.nic}'),
            const SizedBox(height: 5),
            Text('CS Code: ${farmer.csCode}'),
            const SizedBox(height: 5),
            Text('Latitude: ${farmer.latitude}'),
            const SizedBox(height: 5),
            Text('Longitude: ${farmer.longitude}'),
          ],
        ),
      ),
    );
  }
}
