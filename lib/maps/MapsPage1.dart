import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../Settings/db.dart';
import 'package:geocoding/geocoding.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:geolocator/geolocator.dart';

class MapsPage1 extends StatefulWidget {
  @override
  MapsPage1State createState() => MapsPage1State();
}

class MapsPage1State extends State<MapsPage1> {

  Completer<GoogleMapController> _controller = Completer();
  final GeocodingPlatform geocodingPlatform = GeocodingPlatform.instance;
  TextEditingController _cityController = TextEditingController();

  List<Map<String, dynamic>>? _imoveis = [];

  late Position _currentPosition = Position(
    latitude: -22.922334,
    longitude: -47.064010,
    accuracy: 0.0,
    altitude: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
    heading: 0.0,
    timestamp: DateTime.now(),
  );


  _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadImoveis();
    _getCurrentLocation().then((position) {
      if (position != null) {
        setState(() {
          _currentPosition = position;
        });
      } else {

      }
    });
    _controller = Completer();
  }

  Future<void> _loadImoveis() async {
    List<Map<String, dynamic>>? imoveis = await getImoveis();
    setState(() {
      _imoveis = imoveis;
    });
  }

  double zoomVal = 5.0;

  Future<List<Map<String, dynamic>>?> getImoveis() async {
    var db = await Db.getConnectionImoveis();
    var col = db.collection('informacoes');
    final doc = await col.find().toList();

    List<Map<String, dynamic>>? data = doc;

    return data;
  }

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
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFFCED6E0),
                        border: Border.all(width: 1, color: Colors.black)
                    ),
                    child: TextFormField(
                      controller: _cityController,
                      onFieldSubmitted: (value) async{
                        _moveToCity(_cityController.text);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Digite a cidade...',
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
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

    return FutureBuilder<void>(
      future: _addMarkers(markers),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.done) {
          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
                target: LatLng(_currentPosition.latitude, _currentPosition.longitude), zoom: 12),
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
    List<String> ceps = [];
    for (var imovel in _imoveis!) {
      String cep = imovel['endereco']['cep'];
      ceps.add(cep);
    }

    for (var i = 0; i < ceps.length; i++) {
      Map<String, dynamic>? location = await _getLatLngFromCep(ceps[i]);
      if (location != null) {
        double lat = location['lat'];
        double lng = location['lng'];
        markers.add(
          Marker(
            visible: true,
            markerId: MarkerId(ceps[i]),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(
              title: '${_imoveis![i]['tipo']['tipo']} para ${_imoveis![i]['valores']['negocio']}',
              snippet: '${_imoveis![i]['endereco']['rua']}, ${_imoveis![i]['endereco']['bairro']}, ${_imoveis![i]['endereco']['numero']}\nValor: R\$ ${_imoveis![i]['valores']['valor']}',
              onTap: (){
                exibirDetalhes(_imoveis![i]);
              }
            ),
          ),
        );
      }
    }
  }

  Future<Map<String, dynamic>?> _getLatLngFromCep(String cep) async {
    final GeocodingPlatform geocodingPlatform = GeocodingPlatform.instance;
    final placemarks = await geocodingPlatform.locationFromAddress(cep);
    final latitude = placemarks.first.latitude;
    final longitude = placemarks.first.longitude;
    return {'lat': latitude, 'lng': longitude};
  }

  Future<LatLng?> _getLatLngFromCity(String city) async {
    try {
      List<Location> locations = await locationFromAddress(city);
      if (locations.isNotEmpty) {
        return LatLng(locations[0].latitude, locations[0].longitude);
      }
      return null;
    } catch (e) {
      print('Erro ao obter localização da cidade: $e');
      return null;
    }
  }

  Future<void> _moveToCity(String city) async {
    LatLng? latLng = await _getLatLngFromCity(_cityController.text);
    if (latLng != null) {
      final controller = await _controller.future;
      var lat = latLng.latitude;
      var long = latLng.longitude;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, long), zoom: 12, tilt: 50.0, bearing: 45.0)),
      );
    } else {
      print('Não foi possível obter a localização da cidade.');
    }
  }

  void exibirDetalhes(Map<String, dynamic> imovel) {

    String mobiliaText = '';
    if (imovel['caracteristicas']['mobilias'] != null && imovel['caracteristicas']['mobilias'].isNotEmpty) {
      for (int i = 0; i < imovel['caracteristicas']['mobilias'].length; i++) {
        if (i == 0) {
          mobiliaText = imovel['caracteristicas']['mobilias'][i];
        } else {
          mobiliaText = '$mobiliaText, ${imovel['caracteristicas']['mobilias'][i]}';
        }
      }
    } else {
      mobiliaText = 'Nenhuma mobília';
    }

    String switchPets = '';
    if(imovel['caracteristicas']['switchPets'] == true){
      switchPets = 'Aceita';
    }else{
      switchPets = 'Não aceita';
    }

    String tipo = '';
    if(imovel['valores']['negocio'] == "Comprar"){
      tipo = 'Compra';
    }else{
      tipo = 'Aluguel';
    }

    String valor = imovel['valores']['valor'];
    int valorInteiro = int.parse(valor);

    String valorCond = imovel['valores']['valorCond'];
    int valorCondInteiro = int.parse(valorCond);

    String valorIPTU = imovel['valores']['valorIPTU'];
    int valorIPTUInteiro = int.parse(valorIPTU);

    String valorSeguro = imovel['valores']['valorSeguro'];
    int valorSeguroInteiro = int.parse(valorSeguro);

    var valorTotal = valorSeguroInteiro + valorCondInteiro + valorIPTUInteiro + valorInteiro;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 250,
                        width: double.infinity,
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.close),
                              color: Colors.black,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: imovel['imagens'].length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Image.memory(
                                    base64Decode(imovel['imagens'][index]),
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          imovel['tipo']['titulo'],
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rua ${imovel['endereco']['rua']}, ${imovel['endereco']['bairro']}, ${imovel['endereco']['numero']}\n${imovel['endereco']['cidade']}-${imovel['endereco']['uf']}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${imovel['tipo']['tipo']} (${imovel['tipo']['tamanho']}m²) com:',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Quartos: ${imovel['caracteristicas']['numeroQuartos']}\nBanheiros: ${imovel['caracteristicas']['numeroBanheiros']}'
                                  '\nVagas de Carro: ${imovel['caracteristicas']['numeroVagas']}\nPets: $switchPets',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Mobílias: $mobiliaText',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 30),
                            Text(
                              'Valores:',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              height: 180,
                              decoration: BoxDecoration(
                                  color: Color(0xFFEAE2B7),
                                  border: Border.all(width: 2, color: Colors.black)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 12),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Valor ($tipo):'),
                                        Text('R\$ ${imovel['valores']['valor']}'),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Condomínio:'),
                                        Text('R\$ ${imovel['valores']['valorCond']}'),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('IPTU:'),
                                        Text('R\$ ${imovel['valores']['valorIPTU']}'),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Valor Seguro:'),
                                        Text('R\$ ${imovel['valores']['valorSeguro']}'),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Divider(color: Colors.black),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                                        Text('R\$ $valorTotal', style: TextStyle(fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 20, 10, 0),
                        child: FFButtonWidget(
                          onPressed: () async{
                          },
                          text: 'Agendar Visita',
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 61,
                            color: Color(0xFF003049),
                            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                )
            ),
          ),
        );
      },
    );
  }
}
