import 'package:flutter/material.dart';
import 'package:nearby_assist/widgets/avatar.dart';
import 'package:nearby_assist/widgets/map.dart';
import 'package:nearby_assist/widgets/radius_slider.dart';
import 'package:nearby_assist/widgets/search_bar.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPage();
}

class _MapPage extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [Avatar()],
      ),
      body: const Stack(
        children: [
          CustomMap(),
          Align(
            alignment: Alignment.topLeft,
            child: Column(
              children: [
                ServiceSearchBar(),
                RadiusSlider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
