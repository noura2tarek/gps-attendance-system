import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

part 'employee_location_state.dart';

class EmployeeLocationCubit extends Cubit<EmployeeLocationState> {
  EmployeeLocationCubit() : super(EmployeeLocationInitial());
  final double companyLat = 30.0447;
  final double companyLng = 31.2389;
  final double geofenceRadius = 100;

  Future<void> checkEmployeeLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        emit(EmployeeLocationPermissionDenied());
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      double distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          companyLat,
          companyLng,
      );

      if (distance <= geofenceRadius) {
        emit(EmployeeLocationInside());
      } else {
        emit(EmployeeLocationOutside());
      }
    } catch(e) {}
  }
}
