import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as location;
import 'package:geocoding/geocoding.dart' as geocoding;

class LocationProvider with ChangeNotifier {
  TextEditingController locationController = TextEditingController();
  LatLng? userLocation;
  MapController mapController = MapController();
  bool _searchInitiated = false;
  bool get searchInitiated => _searchInitiated;

  Future<void> getLocationFromInput() async {
    final String location = locationController.text;
    try {
      List<geocoding.Location> locations =
          await geocoding.locationFromAddress(location);
      if (locations.isNotEmpty) {
        userLocation =
            LatLng(locations.first.latitude, locations.first.longitude);

        mapController.move(userLocation!, 15.0);
        _searchInitiated = true;
      } else {
        print('Location not found');
      }
    } catch (e) {
      print('Error fetching location: $e');
    }
    notifyListeners();
  }

  Future<void> getLocationFromDevice() async {
    location.LocationData? currentLocation;
    var loc = location.Location();
    try {
      currentLocation = await loc.getLocation();
      userLocation =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);
      mapController.move(userLocation!, 15.0);
      _searchInitiated = false;
    } catch (e) {
      print('Error fetching current location: $e');
    }
    notifyListeners();
  }
}
