import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CompanyLocation extends StatelessWidget {
  const CompanyLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(30.0447, 31.2389),
        zoom: 14,
      ),
      markers: {Marker(markerId: MarkerId('Greek Campus'))},
    );
  }
}
