import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../service/location_service.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map with User Location'),
      ),
      body: Column(
        children: [
          SizedBox(
            width: 300,
            child: TextField(
              controller: context.read<LocationProvider>().locationController,
              decoration: const InputDecoration(
                hintText: 'Enter Location (e.g., New Delhi, India)',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Note: Pinch to Zoom in & Zoom out",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: context.read<LocationProvider>().getLocationFromInput,
            child: const Text('Search'),
          ),
          ElevatedButton(
            onPressed: context.read<LocationProvider>().getLocationFromDevice,
            child: const Text('Current Location'),
          ),
          Expanded(
            child: Consumer<LocationProvider>(
              builder: (context, provider, _) {
                return provider.userLocation != null
                    ? Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: FlutterMap(
                          mapController: provider.mapController,
                          options: MapOptions(
                            initialCenter: provider.userLocation!,
                            initialZoom: 15.0,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            ),
                            RichAttributionWidget(attributions: [
                              TextSourceAttribution(
                                'OpenStreetMap contributors',
                                onTap: () => launchUrl(Uri.parse(
                                    'https://openstreetmap.org/copyright')),
                              )
                            ]),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  width: 80.0,
                                  height: 80.0,
                                  point: provider.userLocation!,
                                  rotate: true,
                                  child: Column(
                                    children: [
                                      context
                                              .read<LocationProvider>()
                                              .searchInitiated
                                          ? const Text("Showing Results for")
                                          : const Text("You're here"),
                                      const Icon(
                                        Icons.location_pin,
                                        size: 40,
                                        color: Colors.blue,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
