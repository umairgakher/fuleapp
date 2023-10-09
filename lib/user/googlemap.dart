// ignore_for_file: unnecessary_import, prefer_final_fields, prefer_const_constructors

import 'dart:async';
import 'package:app/user/location_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  loc.LocationData? _currentLocation;
  TextEditingController _searchController = TextEditingController();
  String _selectedLocationAddress = '';
  String _currentLocationAddress = '';

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(33.847115182244046, 73.74918182667015),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    loc.Location location = loc.Location();
    _currentLocation = await location.getLocation();

    List<Placemark> placemarks = await placemarkFromCoordinates(
      _currentLocation!.latitude!,
      _currentLocation!.longitude!,
    );

    String address = _buildAddressFromPlacemark(placemarks.first);

    setState(() {
      _currentLocationAddress = address;
      LocationController().currentLocation = _currentLocationAddress;
      addMarker(
        markerID: "1",
        latLng:
            LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
      );
    });

    await _goToCurrentLocation();
  }

  Future<void> _searchLocation(String query) async {
    List<Location> locations = await locationFromAddress(query);

    if (locations.isNotEmpty) {
      Location location = locations.first;
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(location.latitude, location.longitude),
            zoom: 14.0,
          ),
        ),
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      String address = _buildAddressFromPlacemark(placemarks.first);

      setState(() {
        _selectedLocationAddress = address;
        LocationController().selectedLocationAddress = _selectedLocationAddress;
        markers.clear();
        addMarker(
          markerID: "2",
          latLng: LatLng(location.latitude, location.longitude),
        );
      });
    }
  }

  String _buildAddressFromPlacemark(Placemark placemark) {
    String street = placemark.street ?? '';
    String subLocality = placemark.subLocality ?? '';
    String locality = placemark.locality ?? '';
    String administrativeArea = placemark.administrativeArea ?? '';
    String postalCode = placemark.postalCode ?? '';
    String country = placemark.country ?? '';

    return '$street, $subLocality, $locality, $administrativeArea $postalCode, $country';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Location',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for a location',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 16.0,
                ),
              ),
              onChanged: (value) {},
              onSubmitted: (value) {
                _searchLocation(value);
              },
            ),
          ),
          Expanded(
            child: GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: _kGooglePlex,
              onTap: (location) async {
                markers.clear();
                addMarker(
                  markerID: "${location.latitude}",
                  latLng: LatLng(location.latitude, location.longitude),
                );

                List<Placemark> placemarks = await placemarkFromCoordinates(
                  location.latitude,
                  location.longitude,
                );
                String address = _buildAddressFromPlacemark(placemarks.first);

                setState(() {
                  _selectedLocationAddress = address;
                  LocationController().selectedLocationAddress =
                      _selectedLocationAddress;
                });
              },
              markers: Set<Marker>.of(markers.values),
              onMapCreated: (GoogleMapController controller) {
                if (!_controller.isCompleted) {
                  _controller.complete(controller);
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              child: Text(
                'Current Location: $_currentLocationAddress',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              child: Text(
                'Selected Location Address: $_selectedLocationAddress',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orange,
        onPressed: _goToTheLake,
        label: const Text(
          'To Nearest!',
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(
          Icons.directions,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  Future<void> _goToCurrentLocation() async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            _currentLocation!.latitude!,
            _currentLocation!.longitude!,
          ),
          zoom: 14.0,
        ),
      ),
    );
  }

  addMarker({required String markerID, required LatLng latLng}) {
    final MarkerId markerId = MarkerId(markerID);

    final Marker marker = Marker(
      markerId: markerId,
      position: latLng,
      infoWindow: InfoWindow(title: "Test", snippet: "this is testing"),
    );

    setState(() {
      markers[markerId] = marker;
    });
  }
}
