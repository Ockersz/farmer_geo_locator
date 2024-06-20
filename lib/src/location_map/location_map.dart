import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationMap extends StatefulWidget {
  final double latitude;
  final double longitude;

  const LocationMap({Key? key, required this.latitude, required this.longitude})
      : super(key: key);

  @override
  _LocationMapState createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  late GoogleMapController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmer Location'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.latitude, widget.longitude),
          zoom: 14.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        markers: {
          Marker(
            markerId: const MarkerId('location_marker'),
            position: LatLng(widget.latitude, widget.longitude),
          ),
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
