import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front_projeto_quintoandar/maps/MapsPage1.dart';
import 'package:front_projeto_quintoandar/Settings/db.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Settings/Snackbar.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'maps/MapsPage2.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class HomePage extends StatefulWidget {

  Map<String, dynamic>? user;

  HomePage({Key? key, required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _scrollController = ScrollController();
  int _currentPage = 1;
  int _pageSize = 3;
  List<Map<String, dynamic>> _imoveis = [];
  List<Map<String, dynamic>> _favoritos = [];
  bool _isFavorito = false;

  late PermissionStatus _permissionStatus;

  Future<void> checkLocationPermission() async {
    final status = await Permission.locationWhenInUse.status;
    setState(() {
      _permissionStatus = status;
    });
  }

  Future<List<Map<String, dynamic>>> getImoveis(int page, int pageSize) async {
    var db = await Db.getConnectionImoveis();
    var col = db.collection('informacoes');
    final doc = await col.find().skip((page - 1) * pageSize).take(pageSize).toList();

    List<Map<String, dynamic>> data = doc;

    if (page == 1) {
      _imoveis = data;
    } else {
      _imoveis.addAll(data);
    }

    return data;
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      setState(() {
        _currentPage++;
      });
      getImoveis(_currentPage, _pageSize);
    }
  }

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
    _scrollController.addListener(_onScroll);
    _loadFavorites();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _saveFavorites() async {
    var doc = widget.user;
    var id = doc!['_id'];

    final prefs = await SharedPreferences.getInstance();
    final existingFavorites = prefs.getStringList('$id') ?? [];
    final existingIds = existingFavorites.map((favorito) => jsonDecode(favorito)['_id'].toString()).toSet();

    final jsonList = _favoritos
        .where((favorito) => !existingIds.contains(favorito['_id'].toString()))
        .map<String>((favorito) => jsonEncode(favorito))
        .toList();

    final mergedList = [...existingFavorites, ...jsonList];
    await prefs.setStringList('$id', mergedList);
  }

  void toggleFavorite(Map<String, dynamic> imovel) async {
    final key = imovel['_id'].toString();

    bool isFavorited = false;
    int index = 0;
    for (int i = 0; i < _favoritos.length; i++) {
      if (_favoritos[i]['_id'].toString() == key) {
        isFavorited = true;
        index = i;
        break;
      }
    }
    if (isFavorited) {
      setState(() {
        _favoritos.removeAt(index);
        _isFavorito = false;
      });
    } else {
      setState(() {
        final novoFavorito = {...imovel};
        _favoritos.add(novoFavorito);
        _isFavorito = true;
      });
    }
    await _saveFavorites();
  }

  void _toggleFavorito(Map<String, dynamic> imovel) async {
    toggleFavorite(imovel);

    var doc = widget.user;
    var id = doc!['_id'];

    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('$id') ?? [];

    final isFavorito = favorites.any((favorito) {
      final decoded = jsonDecode(favorito);
      return decoded['_id'].toString() == imovel['_id'].toString();
    });

    setState(() {
      _isFavorito = isFavorito;
    });
  }

  Future<void> _loadFavorites() async {
    var doc = widget.user;
    var id = doc!['_id'];
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('$id') ?? [];

    setState(() {
      _favoritos = favorites.map<Map<String, dynamic>>((favorito) => jsonDecode(favorito)).toList();
    });
  }

  void exibirDetalhes(Map<String, dynamic> imovel) async{

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
                          children: [
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.chat_outlined),
                                    color: Colors.black,
                                    onPressed: () async{
                                      var db = await Db.getConnection();
                                      var col = db.collection('user');

                                      var id = imovel['_userId'];

                                      var doc = await col.findOne(mongo.where.eq('_id', id));
                                      String email = doc!['email'];

                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Chat do proprietário"),
                                            content: Text("Use o email: $email"),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: Text("Fechar"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.close),
                                    color: Colors.black,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
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
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 20, 10, 0),
                        child: FFButtonWidget(
                          onPressed: () async{
                            String cep = imovel['endereco']['cep'];
                            Navigator.push(context,MaterialPageRoute(builder: (context) => MapsPage2(endereco: cep,)));
                          },
                          text: 'Ver no Mapa',
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
                            DateTime? _dataHora;
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (BuildContext context, StateSetter setState) {
                                    return Scaffold(
                                      body: Container(
                                          margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "Visita ao imóvel",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    icon: Icon(
                                                      Icons.close,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 60),
                                              Padding(
                                                  padding: EdgeInsets.only(right: 10),
                                                child: Text("Selecione a data e hora desejada:",style: TextStyle(
                                                    fontSize: 20
                                                )),
                                              ),
                                              SizedBox(height: 15),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      onPressed: () async {
                                                        final selectedDate = await showDatePicker(
                                                          context: context,
                                                          initialDate: DateTime.now(),
                                                          firstDate: DateTime.now(),
                                                          lastDate: DateTime.now().add(Duration(days: 365)),
                                                        );
                                                        if (selectedDate != null) {
                                                          final selectedTime = await showTimePicker(
                                                            context: context,
                                                            initialTime: TimeOfDay.now(),
                                                          );
                                                          if (selectedTime != null) {
                                                            setState(() {
                                                              _dataHora = DateTime(
                                                                selectedDate.year,
                                                                selectedDate.month,
                                                                selectedDate.day,
                                                                selectedTime.hour,
                                                                selectedTime.minute,
                                                              );
                                                            });
                                                          }
                                                        }
                                                      },
                                                      child: Text('Selecionar'),
                                                      style: ElevatedButton.styleFrom(
                                                        primary: Color(0xFF003049),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                        padding: EdgeInsets.symmetric(vertical: 16),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 40,
                                              ),
                                              Text(
                                                _dataHora != null
                                                    ? 'Data: ${_dataHora!.day}/${_dataHora!.month}/${_dataHora!.year} Hora: ${_dataHora!.hour}:${_dataHora!.minute}'
                                                    : '',
                                                style: TextStyle(
                                                  fontSize: 20
                                                ),
                                              ),
                                              SizedBox(
                                                height: 100,
                                              ),
                                              Center(
                                                child: Text(
                                                    "RESSALTAMOS: O proprietário do imóvel que fica responsável por aceitar ou recusar o pedido.",
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      onPressed: () async {
                                                        var db = await Db.getConnectionImoveis();
                                                        var col = db.collection('informacoes');

                                                        var userSolicitante = widget.user;
                                                        var userSol = userSolicitante!['email'];

                                                        var idProprietario = imovel['_userId'];
                                                        var emailSolicitante = userSol;

                                                        var imovelId = imovel['_id'];
                                                        var idImovel = imovelId;

                                                        String data = '${_dataHora!.day}/${_dataHora!.month}/${_dataHora!.year}';
                                                        String horario = '${_dataHora!.hour}:${_dataHora!.minute}';

                                                        col.updateOne(mongo.where.eq('_id', idImovel), mongo.modify.push('visitasPedidas', {
                                                          'idProprietario' : idProprietario,
                                                          'emailSolicitante' : emailSolicitante,
                                                          'idImovel': idImovel,
                                                          'data' : data,
                                                          'horario' : horario
                                                        }));

                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(content: Text('Pedido de visita enviado')),
                                                        );
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text('Enviar'),
                                                      style: ElevatedButton.styleFrom(
                                                        primary: Color(0xFF003049),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                        padding: EdgeInsets.symmetric(vertical: 16),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                    );
                                  },
                                );
                              },
                            );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.transparent,
          child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 30, left: 30, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Anúncios",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                        )),
                        Row(
                          children: [
                            IconButton(
                                onPressed: (){
                                  Future<void> requestPermission()async{
                                    final status = await Permission.locationWhenInUse.request();
                                    setState(() {
                                      _permissionStatus = status;
                                    });
                                    if(_permissionStatus == PermissionStatus.granted){
                                      Navigator.push(context,MaterialPageRoute(builder: (context) => new MapsPage1()));
                                    }else{
                                      CustomSnackBarError(context, const Text('Permissão de localização negada'));
                                    }
                                  }

                                  if(_permissionStatus == PermissionStatus.granted){
                                    Navigator.push(context,MaterialPageRoute(builder: (context) => new MapsPage1()));
                                  }
                                  if(_permissionStatus == PermissionStatus.denied || _permissionStatus != PermissionStatus.granted){
                                    requestPermission();
                                  }
                                },
                                icon: Icon(Icons.map_outlined, color: Colors.black,),
                            ),
                            IconButton(
                                onPressed: (){
                                },
                                icon: Icon(Icons.filter_alt_outlined, color: Colors.black,)
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                      height: 550,
                      child: SizedBox(
                        child: FutureBuilder(
                            future: getImoveis(_currentPage, _pageSize),
                            builder: (context, snapshot){
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(height: 10,),
                                        Text("Carregando anúncios...")
                                      ],
                                    ));
                              }
                              if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error}'));
                              }
                              if (_imoveis.isEmpty) {
                                return Center(child: Text('Nenhum imóvel encontrado.'));
                              }
                              return ListView.builder(
                                  controller: _scrollController,
                                  itemCount: _imoveis.length,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index){
                                    if (index == _imoveis.length) {
                                      return Container(
                                        height: 50,
                                        alignment: Alignment.center,
                                        child: Text('Puxe para atualizar'),
                                      );
                                    } else {
                                      return Align(
                                        alignment: AlignmentDirectional(0, 0),
                                        child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 40),
                                          child: InkWell(
                                            onTap: (){
                                              exibirDetalhes(_imoveis[index]);
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              margin: EdgeInsets.only(left: 20, right: 20),
                                              height: 320,
                                              decoration: BoxDecoration(
                                                color: Color(0xffF0F0F0),
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 2,
                                                    color: Colors.black,
                                                  )
                                                ],
                                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    width: double.infinity,
                                                    height: 160,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.only(
                                                          topRight: Radius.circular(8),
                                                          topLeft: Radius.circular(8)
                                                      ),
                                                    ),
                                                    child: ListView.builder(
                                                      scrollDirection: Axis.horizontal,
                                                      itemCount: _imoveis[index]['imagens'].length,
                                                      itemBuilder: (BuildContext context, int imgIndex) {
                                                        return Image.memory(
                                                          base64Decode(_imoveis[index]['imagens'][imgIndex]),
                                                          fit: BoxFit.cover,
                                                          width: 300,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Expanded(
                                                          child: Align(
                                                            alignment: AlignmentDirectional(-1, -1),
                                                            child: Text(
                                                              '${_imoveis[index]['tipo']['tipo']}',
                                                              textAlign: TextAlign.start,
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.bold
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 70,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(2),
                                                            color: Color(0xFF003049),
                                                          ),
                                                          child: Center(
                                                              child: Text('${_imoveis[index]['valores']['negocio']}', style: TextStyle(color: Colors.white),)
                                                          )
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      children: [
                                                        Text(
                                                          '\nRua ${_imoveis[index]['endereco']['rua']},\n${_imoveis[index]['endereco']['bairro']},'
                                                              '\n${_imoveis[index]['endereco']['cidade']} - ${_imoveis[index]['endereco']['uf']}',
                                                          style: TextStyle(fontWeight: FontWeight.w500),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                            'Valor: R\$ ${_imoveis[index]['valores']['valor']}',
                                                          style: TextStyle(color: Color(0xFF003049), fontWeight: FontWeight.bold),
                                                        ),
                                                        InkWell(
                                                          child: Icon(
                                                            _isFavorito ? Icons.favorite : Icons.favorite_border,
                                                            color: _isFavorito ? Colors.red : Colors.black,
                                                          ),
                                                          onTap: () {
                                                            final imovel = _imoveis[index];
                                                            final isFavorito = _favoritos.any((favorito) => favorito['_id'] == imovel['_id']);
                                                            if (!isFavorito) {
                                                              _toggleFavorito(imovel);
                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                SnackBar(content: Text('Imóvel adicionado aos favoritos')),
                                                              );
                                                            } else {
                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                SnackBar(content: Text('Este imóvel já está nos seus favoritos')),
                                                              );
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  }
                              );
                            }
                        ),
                      )
                  ),
                ],
              )
          )
      ),
    );
  }
}