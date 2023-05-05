import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class MapsPage2 extends StatefulWidget {

  String endereco;

  MapsPage2({Key? key, required this.endereco}) : super(key: key);

  @override
  MapsPage2State createState() => MapsPage2State();
}

class MapsPage2State extends State<MapsPage2> {

  Completer<GoogleMapController> _controller = Completer();
  final GeocodingPlatform geocodingPlatform = GeocodingPlatform.instance;

  @override
  void initState() {
    super.initState();
    _controller = Completer();
  }

  double zoomVal = 5.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildGoogleMap(context),
          Container(
            height: 40,
            margin: EdgeInsets.only(top: 40, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.close, color: Colors.black, size: 30),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    Set<Marker> markers = Set();
    _addMarkers(markers);

    return FutureBuilder<Map<String, dynamic>?>(
      future: _getLatLngFromCep(widget.endereco),
      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          final location = snapshot.data!;
          double lat = location['lat']!;
          double lng = location['lng']!;
          CameraPosition initialCameraPosition = CameraPosition(
            target: LatLng(lat, lng),
            zoom: 12,
          );
          markers.add(
            Marker(
              visible: true,
              markerId: MarkerId(widget.endereco),
              position: LatLng(lat, lng),
              infoWindow: InfoWindow(
                title: 'Você está vendo esse imóvel',
              ),
            ),
          );
          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: initialCameraPosition,
            onMapCreated: (GoogleMapController controller) {
              if (!_controller.isCompleted) {
                _controller.complete(controller);
              }
            },
            markers: markers,
          );
        } else {
          return Center(child: Text('Erro ao carregar o mapa'),);
        }
      },
    );
  }

  Future<void> _addMarkers(Set<Marker> markers) async {
    String cep = widget.endereco;

    Map<String, dynamic>? location = await _getLatLngFromCep(cep);

    if (location != null) {
      double lat = location['lat'];
      double lng = location['lng'];
      markers.add(
        Marker(
          visible: true,
          markerId: MarkerId(cep),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: 'Você está vendo esse imóvel',
          ),
        ),
      );
    }
  }

  Future<Map<String, dynamic>?> _getLatLngFromCep(String cep) async {
    final GeocodingPlatform geocodingPlatform = GeocodingPlatform.instance;
    final placemarks = await geocodingPlatform.locationFromAddress(cep);
    final latitude = placemarks.first.latitude;
    final longitude = placemarks.first.longitude;
    return {'lat': latitude, 'lng': longitude};
  }
}