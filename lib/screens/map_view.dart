import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobileprism/constants/package.dart';

class MapView extends StatelessWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(40, 30),
          zoom: 3,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.de/{z}/{x}/{y}.png",
            userAgentPackageName: packageName,
            subdomains: ["a", "b", "c"],
          ),
          MarkerLayerOptions(
            markers: [
              Marker(
                point: LatLng(30, 40),
                width: 40,
                height: 40,
                builder: (context) => InkWell(
                  onTap: () {
                    log("Ich wurde getapt");
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 1,
                          spreadRadius: 1,
                        )
                      ],
                    ),
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('images/1.jpg'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
