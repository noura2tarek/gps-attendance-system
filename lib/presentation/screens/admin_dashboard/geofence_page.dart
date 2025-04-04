import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_attendance_system/l10n/l10n.dart';
import 'package:gps_attendance_system/presentation/widgets/snakbar_widget.dart';

class GeofencePage extends StatefulWidget {
  const GeofencePage({super.key});

  @override
  State<GeofencePage> createState() => _GeofencePageState();
}

class _GeofencePageState extends State<GeofencePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  GoogleMapController? _googleMapController;
  LatLng? _location;
  Set<Circle> _circle = {};

  void _updateCircle(LatLng newLocation) {
    setState(() {
      _circle = {
        Circle(
          circleId: const CircleId('value'),
          center: newLocation,
          radius: 100,
          strokeWidth: 2,
          strokeColor: Colors.blue,
          fillColor: Colors.blue.withValues(alpha: 0.3),
        ),
      };
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _googleMapController = controller;
  }

  void _onMapTap(LatLng loc) {
    setState(() {
      _location = loc;
      _updateCircle(loc);
    });
  }

  Future<void> _saveLocation() async {
    if (_location == null) return;
    await _firestore.collection('company-location').doc('company-location').set(
      {'latitude': _location!.latitude, 'longitude': _location!.longitude},
    );
    CustomSnackBar.show(
      context,
      'New Geofence added succusfully',
      color: chooseSnackBarColor(ToastStates.SUCCESS),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geofence'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            onTap: _onMapTap,
            initialCameraPosition: const CameraPosition(
                target: LatLng(30.0444, 31.2357), zoom: 15),
            markers: _location == null
                ? {}
                : {
                    Marker(
                      markerId: const MarkerId('Your Company'),
                      position: _location!,
                    ),
                  },
            circles: _circle,
          ),
          if (_location != null)
            Positioned(
              bottom: 20,
              left: 20,
              child: ElevatedButton(
                onPressed: _saveLocation,
                child: Text(AppLocalizations.of(context).saveLoc),
              ),
            ),
        ],
      ),
    );
  }
}
