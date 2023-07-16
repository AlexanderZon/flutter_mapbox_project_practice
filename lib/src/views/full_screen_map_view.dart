import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FullScreenMapView extends StatefulWidget {
   
  const FullScreenMapView({Key? key}) : super(key: key);

  @override
  State<FullScreenMapView> createState() => _FullScreenMapViewState();
}

class _FullScreenMapViewState extends State<FullScreenMapView> {
  MapboxMapController? mapController;

  var isLight = true;

  _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  _onStyleLoadedCallback() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Style loaded :)"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 1),
    ));
  }

  @override
  Widget build(BuildContext context) {
    String ACCESS_TOKEN = dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? "";
    return Scaffold(
      body: MapboxMap(
        styleString: MapboxStyles.LIGHT,
        accessToken: ACCESS_TOKEN,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(37.810575, -122.477174),
          zoom: 10
        ),
        onStyleLoadedCallback: _onStyleLoadedCallback,
      ),
    );
  }
}