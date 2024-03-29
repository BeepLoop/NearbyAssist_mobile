import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/service_model.dart';
import 'package:nearby_assist/services/location_service.dart';
import 'package:nearby_assist/services/search_service.dart';

class CustomMap extends StatefulWidget {
  const CustomMap({super.key});

  @override
  State<CustomMap> createState() => _CustomMap();
}

class _CustomMap extends State<CustomMap> {
  final currentLocation = getIt.get<LocationService>().getLocation();

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: currentLocation,
        initialZoom: 16.0,
      ),
      children: [
        TileLayer(
          urlTemplate: tileMapProvider,
          userAgentPackageName: 'com.example.app',
        ),
        ListenableBuilder(
          listenable: getIt.get<SearchingService>(),
          builder: (context, child) {
            final serviceLocations =
                getIt.get<SearchingService>().getServiceLocations();

            return MarkerLayer(
              markers: [
                Marker(
                    point: currentLocation,
                    child: const Icon(
                      Icons.pin_drop,
                      color: Colors.redAccent,
                    )),
                ..._markerBuilder(serviceLocations),
              ],
            );
          },
        ),
        ListenableBuilder(
          listenable: getIt.get<SearchingService>(),
          builder: (context, child) {
            final radius = getIt.get<SearchingService>().getRadius();

            return CircleLayer(
              circles: [
                CircleMarker(
                  point: currentLocation,
                  radius: radius,
                  color: Colors.blue.withOpacity(0.3),
                  useRadiusInMeter: true,
                )
              ],
            );
          },
        ),
      ],
    );
  }

  List<Marker> _markerBuilder(List<Service> serviceLocations) {
    List<Marker> markers = [];

    for (var service in serviceLocations) {
      markers.add(
        Marker(
          point: LatLng(service.latitude, service.longitude),
          child: GestureDetector(
            onTap: () {
              context.goNamed(
                'vendor',
                pathParameters: {'vendor': '${service.id}'},
              );
            },
            child: const Icon(Icons.pin_drop, color: Colors.red),
          ),
        ),
      );
    }

    return markers;
  }
}
