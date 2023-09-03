// ignore_for_file: empty_constructor_bodies, unused_field

class LocationController {
  static final LocationController _session = LocationController._internal();
  String? currentLocation;
  String? selectedLocationAddress;
  factory LocationController() {
    return _session;
  }

  LocationController._internal() {}
}
