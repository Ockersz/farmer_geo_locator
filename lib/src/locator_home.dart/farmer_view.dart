import 'package:flutter/material.dart';

class FarmerView extends StatelessWidget {
  final String farmerName;
  final String fieldName;
  final double longitude;
  final double latitude;

  FarmerView({
    required this.farmerName,
    required this.fieldName,
    required this.longitude,
    required this.latitude,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(5),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Farmer Profile',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Name:',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    farmerName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Field:',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    fieldName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Longitude:',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    longitude.toString(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Latitude:',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    latitude.toString(),
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
