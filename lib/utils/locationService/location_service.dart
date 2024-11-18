import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utils/getStore/get_store.dart';
import 'package:geolocator/geolocator.dart';


Future<Position> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (serviceEnabled == false) {
    Geolocator.openLocationSettings();
  }
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  GetStoreData.locationData(
      longitude: position.longitude, latitude: position.latitude);
  return position;
}

LatLngBounds boundsFromLatLngList(List<LatLng> list) {
  assert(list.isNotEmpty);
  double? x0, x1, y0, y1;
  for (LatLng latLng in list) {
    if (x0 == null) {
      x0 = x1 = latLng.latitude;
      y0 = y1 = latLng.longitude;
    } else {
      if (latLng.latitude > (x1 ?? 0)) x1 = latLng.latitude;
      if (latLng.latitude < x0) x0 = latLng.latitude;
      if (latLng.longitude > (y1 ?? 0)) y1 = latLng.longitude;
      if (latLng.longitude < (y0 ?? double.infinity)) y0 = latLng.longitude;
    }
  }
  return LatLngBounds(
    northeast: LatLng(x1 ?? 0, y1 ?? 0),
    southwest: LatLng(x0 ?? 0, y0 ?? 0),
  );
}
