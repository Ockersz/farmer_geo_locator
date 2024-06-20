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
              title: Text('${farmer.farmerName}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      )),
              subtitle: Text('ID: ${farmer.farmerId}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Field Code:',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    farmer.fieldCode,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Text(
                  'Latitude :',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    farmer.latitude.toString(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Text(
                  'Longitude :',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    farmer.longitude.toString(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
