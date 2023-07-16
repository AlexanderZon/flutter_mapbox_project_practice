import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
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
    _onStyleLoaded();
  }

  _onStyleLoadedCallback() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Style loaded :)"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 1),
    ));
    
    _onStyleLoaded();
  }

  _onStyleLoaded() {
    addImageFromAsset("assetImage", "assets/symbols/custom-icon.png");
    addImageFromUrl("networkImage", Uri.https("via.placeholder.com", "50"));
  }

  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController!.addImage(name, list);
  }

  Future<void> addImageFromUrl(String name, Uri url) async {
    var response = await http.get(url);
    return mapController!.addImage(name, response.bodyBytes);
  }

  LatLng center = LatLng(37.810575, -122.477174);

  String ACCESS_TOKEN = dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? "";
  String custom_style = dotenv.env['STYLE_STRING'] ?? "";
  String default_style = MapboxStyles.DARK;
  String STYLE_STRING = dotenv.env['STYLE_STRING'] ?? "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: createMap(),
      floatingActionButton: floatingButtons(),
    );
  }

  Column floatingButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Símbolos

        FloatingActionButton(
          onPressed: () {
            if(mapController != null){
              mapController!.addSymbol(SymbolOptions(
                geometry: center,
                // iconImage: 'mountain-15',
                // iconImage: 'networkImage',
                iconImage: 'assetImage',
                // iconSize: 3,
                textField: 'Montaña creada',
                textOffset: Offset(0, 2),
                textColor: '#cccccc'
              ));
            }
          },
          child: Icon(Icons.sentiment_very_satisfied),
        ),
        SizedBox(height: 10,),
        FloatingActionButton(
          onPressed: () {
            if(mapController != null){
              mapController!.animateCamera(CameraUpdate.zoomIn());
            }
          },
          child: Icon(Icons.zoom_in),
        ),
        SizedBox(height: 10,),
        FloatingActionButton(
          onPressed: () {
            if(mapController != null){
              mapController!.animateCamera(CameraUpdate.zoomOut());
            }
          },
          child: Icon(Icons.zoom_out),
        ),
        SizedBox(height: 10,),
        FloatingActionButton(
          onPressed: () {
            if(STYLE_STRING == custom_style) {
              STYLE_STRING = default_style;
            } else {
              STYLE_STRING = custom_style;
            }
            setState(() { });
          },
          child: Icon(Icons.add_to_home_screen)
        ),
      ],
    );
  }

  MapboxMap createMap() {
    return MapboxMap(
      styleString: STYLE_STRING,
      accessToken: ACCESS_TOKEN,
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: center,
        zoom: 15
      ),
      onStyleLoadedCallback: _onStyleLoadedCallback,
    );
  }
}