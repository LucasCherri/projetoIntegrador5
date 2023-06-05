import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front_projeto_quintoandar/maps/MapsPage1.dart';
import 'package:front_projeto_quintoandar/Settings/db.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'Settings/Snackbar.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'maps/MapsPage2.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:flutter_pdfview/flutter_pdfview.dart';

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
  Future<List<Map<String, dynamic>>>? _imoveisFuture;
  List<Map<String, dynamic>> _favoritos = [];
  bool _isFavorito = false;

  late PermissionStatus _permissionStatus;

  TextEditingController cityController = TextEditingController();
  String selectedTransactionType = 'Alugar';
  String selectedPropertyType = 'Casa';
  double minValue = 0.0;

  List<String> transactionTypes = ['Alugar', 'Comprar'];
  List<String> propertyTypes = ['Casa', 'Apartamento', 'Casa Cond.', 'Kitnet'];

  TextEditingController _valorDesejadoController = TextEditingController();
  TextEditingController _valorMaximoController = TextEditingController();

  Future<void> _gerarPDF(Map<String, dynamic> imovel) async {

    var userSolicitante = widget.user;

    var name = userSolicitante!['nome'];
    var emaill = userSolicitante['email'];
    var celular = userSolicitante['celular'];
    var idSolicitante = userSolicitante['_id'];

    String nome = name;
    String email = emaill;
    String cel = celular;
    String valorDesejado = _valorDesejadoController.text;
    String valorMaximo = _valorMaximoController.text;

    final pdf = pdfWidgets.Document();

    pdf.addPage(
      pdfWidgets.Page(
        build: (context) {
          return pdfWidgets.Column(
            crossAxisAlignment: pdfWidgets.CrossAxisAlignment.start,
            children: [
              pdfWidgets.Text('Proposta para ${imovel['valores']['negocio']}', style: pdfWidgets.TextStyle(fontWeight: pdfWidgets.FontWeight.bold, fontSize: 30)),
              pdfWidgets.SizedBox(height: 20),
              pdfWidgets.Text('Endereço do imóvel:\nRua ${imovel['endereco']['rua']}, ${imovel['endereco']['bairro']}, ${imovel['endereco']['numero']}', style: pdfWidgets.TextStyle(fontSize: 15)),
              pdfWidgets.Text('CEP: ${imovel['endereco']['cep']}, ${imovel['endereco']['cidade']} (${imovel['endereco']['uf']})', style: pdfWidgets.TextStyle(fontSize: 15)),
              pdfWidgets.SizedBox(height: 20),
              pdfWidgets.Text('Valor desejado pelo solicitante: $valorDesejado\nValor máximo a ser pago pelo solicitante: $valorMaximo', style: pdfWidgets.TextStyle(fontSize: 15)),
              pdfWidgets.SizedBox(height: 40),
              pdfWidgets.Text('Esta proposta tem por finalidade assegurar uma oferta (${imovel['valores']['negocio']}) para um imóvel de sua propriedade.', style: pdfWidgets.TextStyle(fontSize: 18)),
              pdfWidgets.SizedBox(height: 10),
              pdfWidgets.Text('Proposta: $nome deseja realizar uma proposta para o imóvel localizado no endereço citado acima '
                  '(${imovel['tipo']['titulo']}, ${imovel['tipo']['tipo']} (${imovel['tipo']['tamanho']}m²)).', style: pdfWidgets.TextStyle(fontSize: 18)),
              pdfWidgets.SizedBox(height: 20),
              pdfWidgets.Table.fromTextArray(
                context: context,
                data: [
                  ['Nome', 'Email', 'Celular', 'Valor desejado', 'Valor máximo'],
                  [nome, email, cel, valorDesejado, valorMaximo],
                ],
                cellAlignment: pdfWidgets.Alignment.center,
                cellStyle: pdfWidgets.TextStyle(
                  fontWeight: pdfWidgets.FontWeight.bold,
                ),
                headerDecoration: pdfWidgets.BoxDecoration(
                  color: PdfColors.grey300,
                  borderRadius: pdfWidgets.BorderRadius.circular(5),
                ),
                cellHeight: 30,
              ),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/proposta_comercial.pdf');
    await file.writeAsBytes(await pdf.save());

    final filePath = file.path;

    final bytes = await file.readAsBytes();
    final base64PDF = base64Encode(bytes);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF003049),
            title: Text('Visualizar Proposta'),
          ),
          body: PDFView(
            filePath: filePath,
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () async{
                var db = await Db.getConnection();
                var col = db.collection('proposta');

                var idProprietario = imovel['_userId'];

                col.insertOne({
                  'idSolicitante': idSolicitante,
                  'idProprietario': idProprietario,
                  'proposta' : base64PDF,
                  'status' : 'Em análise'
                });

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Proposta enviada com sucesso.')),
                );
              },
              child: Text('Enviar Proposta'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF003049)),
              ),
            ),

          ),
        ),
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Proposta Gerada'),
          content: Text('A proposta foi gerada com sucesso!'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

  }

  Future<void> checkLocationPermission() async {
    final status = await Permission.locationWhenInUse.status;
    setState(() {
      _permissionStatus = status;
    });
  }

  Future<List<Map<String, dynamic>>> getImoveis(int page, int pageSize, {String? tipoImovel, String? valorMaximo, String? cidade, String? negocio, String? quartos, String? banheiros, String? vagas}) async {
    var db = await Db.getConnectionImoveis();
    var col = db.collection('informacoes');

    var query = mongo.where.eq('status', 'ativo');

    if (tipoImovel != null && tipoImovel.isNotEmpty) {
      query = query.eq('tipo.tipo', tipoImovel);
    }
    if (valorMaximo != null && valorMaximo.isNotEmpty) {
      query = query.lte('valores.valor', valorMaximo);
    }
    if (cidade != null && cidade.isNotEmpty) {
      query = query.eq('endereco.cidade', cidade);
    }
    if (negocio != null && negocio.isNotEmpty) {
      query = query.eq('valores.negocio', negocio);
    }
    if (quartos != null && quartos.isNotEmpty) {
      query = query.eq('caracteristicas.numeroQuartos', quartos);
    }
    if (banheiros != null && banheiros.isNotEmpty) {
      query = query.eq('caracteristicas.numeroBanheiros', banheiros);
    }
    if (vagas != null && vagas.isNotEmpty) {
      query = query.eq('caracteristicas.numeroVagas', vagas);
    }

    final doc = await col.find(query).skip((page - 1) * pageSize).take(pageSize).toList();

    List<Map<String, dynamic>> data = doc;

    if (page == 1) {
      _imoveis = List<Map<String, dynamic>>.from(data);
    } else {
      for (var imovel in data) {
        var imovelId = imovel['_id'];
        if (!_imoveis.any((existingImovel) => existingImovel['_id'] == imovelId)) {
          _imoveis.add(imovel);
        }
      }
    }

    return _imoveis;
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
    _imoveisFuture = getImoveis(_currentPage, _pageSize);
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

    final jsonList = _favoritos.map<String>((favorito) => jsonEncode(favorito)).toList();

    final mergedList = jsonList.toSet().union(existingFavorites.toSet()).toList();
    await prefs.setStringList('$id', mergedList);
  }

  void toggleFavorite(Map<String, dynamic> imovel) async {
    final key = imovel['_id'].toString();

    final isFavorited = _favoritos.any((favorito) => favorito['_id'].toString() == key);
    if (isFavorited) {
      setState(() {
        _favoritos.removeWhere((favorito) => favorito['_id'].toString() == key);
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

  void exibirDetalhes(Map<String, dynamic> imovel) async {

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

    var userSolicitante = widget.user;

    var nome = userSolicitante!['nome'];
    var email = userSolicitante['email'];
    var celular = userSolicitante['celular'];

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
                            Row(
                              children: [
                                Icon(Icons.bed_sharp),
                                Text(
                                  ' Quartos: ${imovel['caracteristicas']['numeroQuartos']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.bathtub_outlined),
                                Text(
                                  ' Banheiros: ${imovel['caracteristicas']['numeroBanheiros']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.directions_car_filled_outlined),
                                Text(
                                  ' Vagas de Carro: ${imovel['caracteristicas']['numeroVagas']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Wrap(
                              children: [
                                Icon(Icons.chair_outlined),
                                Text(
                                  ' Mobílias: $mobiliaText',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.pets_outlined),
                                Text(
                                  ' Pets: $switchPets',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
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
                            DateTime? selectedDate;
                            TimeOfDay? selectedTime;
                            int? selectedTimeIndex;

                            bool isTimeSlotBooked(String time) {
                              return false;
                            }

                            List<String> availableTimes = ['08:00', '09:00', '10:00', '11:00', '13:00', '14:00', '15:00', '16:00', '17:00', '18:00'];

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  insetPadding: EdgeInsets.zero,
                                  child: StatefulBuilder(
                                    builder: (BuildContext context, StateSetter setState) {
                                      return SingleChildScrollView(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                                          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              Container(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Agendamento",
                                                      style: TextStyle(
                                                        fontSize: 25,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      icon: Icon(Icons.close, size: 30),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  height: 200,
                                                  child: TableCalendar(
                                                    firstDay: DateTime.utc(2023, 1, 1),
                                                    lastDay: DateTime.utc(2023, 12, 31),
                                                    focusedDay: DateTime.now(),
                                                    headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true),
                                                    selectedDayPredicate: (day) => isSameDay(day, selectedDate),
                                                    onDaySelected: (selectedDay, focusedDay) {
                                                      setState(() {
                                                        selectedDate = selectedDay;
                                                      });
                                                    },
                                                    calendarStyle: CalendarStyle(
                                                      selectedDecoration: BoxDecoration(
                                                        color: Color(0xFF003049),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      selectedTextStyle: TextStyle(color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Container(
                                                child: selectedDate != null
                                                    ? Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(height: 8),
                                                    SingleChildScrollView(
                                                      scrollDirection: Axis.horizontal,
                                                      child: Row(
                                                        children: availableTimes.asMap().entries.map((entry) {
                                                          final index = entry.key;
                                                          final time = entry.value;
                                                          final isAvailable = !isTimeSlotBooked(time);
                                                          final isSelected = index == selectedTimeIndex;

                                                          return Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                            child: ElevatedButton(
                                                              onPressed: isAvailable
                                                                  ? () {
                                                                setState(() {
                                                                  selectedTimeIndex = index;
                                                                  selectedTime = TimeOfDay(hour: int.parse(time.split(':')[0]), minute: 0);
                                                                });
                                                              }
                                                                  : null,
                                                              style: ButtonStyle(
                                                                backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                                                                  if (states.contains(MaterialState.disabled)) {
                                                                    return Colors.red;
                                                                  }
                                                                  if (isSelected) {
                                                                    return Colors.green;
                                                                  }
                                                                  return Color(0xFF003049);
                                                                }),
                                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(10),
                                                                  ),
                                                                ),
                                                                minimumSize: MaterialStateProperty.all<Size>(
                                                                  Size(100, 40),
                                                                ),
                                                                padding: MaterialStateProperty.all<EdgeInsets>(
                                                                  EdgeInsets.symmetric(vertical: 8),
                                                                ),
                                                              ),
                                                              child: Text(
                                                                time,
                                                                style: TextStyle(
                                                                  color: isAvailable ? Colors.white : Colors.white.withOpacity(0.6),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                                    : SizedBox(),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Container(
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                ),
                                                padding: EdgeInsets.symmetric(horizontal: 20),
                                                child: selectedDate != null && selectedTime != null
                                                    ? Center(
                                                  child: Text(
                                                    '${DateFormat('dd/MM/yyyy').format(selectedDate!)} ${selectedTime!.format(context)}',
                                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                                  ),
                                                )
                                                    : SizedBox(),
                                              ),
                                              ElevatedButton(
                                                onPressed: () async{

                                                  var db = await Db.getConnectionImoveis();
                                                  var col = db.collection('informacoes');

                                                  var userSol = userSolicitante['email'];

                                                  var idProprietario = imovel['_userId'];
                                                  var emailSolicitante = userSol;

                                                  var imovelId = imovel['_id'];
                                                  var idImovel = imovelId;

                                                  if (selectedDate != null && selectedTime != null) {

                                                    var data = '${DateFormat('dd/MM/yyyy').format(selectedDate!)}';
                                                    var horario = '${selectedTime!.format(context)}';

                                                    col.updateOne(mongo.where.eq('_id', idImovel), mongo.modify.push('visitasPedidas', {
                                                      'idProprietario' : idProprietario,
                                                      'emailSolicitante' : emailSolicitante,
                                                      'idImovel': idImovel,
                                                      'data' : data,
                                                      'horario' : horario
                                                    }));

                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(content: Text('Pedido enviado')),
                                                    );
                                                    Navigator.of(context).pop();

                                                  } else {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(content: Text('Selecione uma data e horário')),
                                                    );
                                                  }
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF003049)),
                                                ),
                                                child: Text('Enviar'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
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
                      Center(
                        child: InkWell(
                          child: Text("Quero fazer uma proposta",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue
                          )),
                          onTap: (){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                    builder: (BuildContext context, StateSetter setState){
                                      return Scaffold(
                                        body: Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            color: Color(0xFF003049),
                                            child: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(top: 30, left: 30, right: 30),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text("Sua proposta",
                                                              style: TextStyle(
                                                                  fontSize: 25,
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.bold
                                                              )),
                                                          IconButton(
                                                            icon: Icon(Icons.close,
                                                                color: Colors.white,
                                                                size: 30),
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(top: 40, left: 30, right: 30),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text("Seus dados",
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.bold
                                                              )),
                                                          SizedBox(height: 16),
                                                          TextField(
                                                            decoration: InputDecoration(
                                                                hintText: nome,
                                                              labelStyle: TextStyle(color: Colors.white),
                                                              hintStyle: TextStyle(color: Colors.white),
                                                            ),
                                                            readOnly: true,
                                                          ),
                                                          SizedBox(height: 16),
                                                          TextField(
                                                            decoration: InputDecoration(
                                                                hintText: celular,
                                                              labelStyle: TextStyle(color: Colors.white),
                                                              hintStyle: TextStyle(color: Colors.white),
                                                            ),
                                                            readOnly: true,
                                                          ),
                                                          SizedBox(height: 16),
                                                          TextField(
                                                            decoration: InputDecoration(
                                                                hintText: email,
                                                              labelStyle: TextStyle(color: Colors.white),
                                                              hintStyle: TextStyle(color: Colors.white),
                                                            ),
                                                            readOnly: true,
                                                          ),
                                                          SizedBox(height: 40),
                                                          Text("Valores",
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.bold
                                                              )),
                                                          SizedBox(height: 16),
                                                          TextField(
                                                            controller: _valorDesejadoController,
                                                            style: TextStyle(color: Colors.white),
                                                            decoration: InputDecoration(
                                                              labelText: 'Valor desejado',
                                                              labelStyle: TextStyle(color: Colors.white),
                                                              hintStyle: TextStyle(color: Colors.white),
                                                            ),
                                                          ),
                                                          SizedBox(height: 16),
                                                          TextField(
                                                            controller: _valorMaximoController,
                                                            style: TextStyle(color: Colors.white),
                                                            decoration: InputDecoration(
                                                              labelText: 'Valor máximo',
                                                              labelStyle: TextStyle(color: Colors.white),
                                                              hintStyle: TextStyle(color: Colors.white),
                                                            ),
                                                          ),
                                                          SizedBox(height: 30),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              TextButton(
                                                                child: Text('Gerar Proposta', style: TextStyle(color: Colors.white, fontSize: 20, decoration: TextDecoration.underline)),
                                                                onPressed: () {
                                                                  if(_valorDesejadoController.text.isEmpty || _valorMaximoController.text.isEmpty){
                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                      SnackBar(content: Text('Preencha todos os campos de valores.')),
                                                                    );
                                                                  }else{
                                                                    _gerarPDF(imovel);
                                                                    Navigator.of(context).pop();
                                                                  }
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )
                                            )
                                        ),
                                      );
                                    }
                                );
                              },
                            );
                          },
                        )
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

  Future<void> filtro() async {
    String tipoImovel = 'Casa';
    String valorMaximo = '';
    String cidade = '';
    String negocio = 'Alugar';
    String quartos = '1';
    String banheiros = '1';
    String vagas = '1';

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              insetPadding: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Filtro de Imóveis',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Informações',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            TextFormField(
                              onChanged: (value) => cidade = value,
                              decoration: InputDecoration(
                                labelText: 'Cidade',
                                labelStyle: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              onChanged: (value) => valorMaximo = value,
                              decoration: InputDecoration(
                                labelText: 'Valor Máximo',
                                labelStyle: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: "Tipo de Imóvel",
                                labelStyle: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                              value: tipoImovel,
                              onChanged: (newValue) {
                                setState(() {
                                  tipoImovel = newValue!;
                                });
                              },
                              items: <String>['Casa', 'Apartamento', 'Casa de Condomínio', 'Kitnet']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: "Negócio",
                                labelStyle: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                              value: negocio,
                              onChanged: (newValue) {
                                setState(() {
                                  negocio = newValue!;
                                });
                              },
                              items: <String>['Alugar', 'Comprar']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Características',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: "Quantidade de Quartos",
                                labelStyle: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                              value: quartos,
                              onChanged: (newValue) {
                                setState(() {
                                  quartos = newValue!;
                                });
                              },
                              items: <String>['1', '2', '3', '4', '5', '6', '7', '8', '9', '10']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: "Quantidade de Banheiros",
                                labelStyle: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                              value: banheiros,
                              onChanged: (newValue) {
                                setState(() {
                                  banheiros = newValue!;
                                });
                              },
                              items: <String>['1', '2', '3', '4', '5', '6', '7', '8', '9', '10']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: "Quantidade de Vagas",
                                labelStyle: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                              value: vagas,
                              onChanged: (newValue) {
                                setState(() {
                                  vagas = newValue!;
                                });
                              },
                              items: <String>['1', '2', '3', '4', '5', '6', '7', '8', '9', '10']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        TextButton(
                          child: Text(
                            'Cancelar',
                            style: TextStyle(color: Colors.black54),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text(
                            'Aplicar Filtros',
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            Navigator.pop(context, {
                              'tipoImovel': tipoImovel,
                              'valorMaximo': valorMaximo,
                              'cidade': cidade,
                              'negocio': negocio,
                              'quartos': quartos,
                              'banheiros': banheiros,
                              'vagas': vagas,
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );


    if (result != null) {
      _imoveisFuture = getImoveis(
        _currentPage, _pageSize,
        tipoImovel: result['tipoImovel'],
        valorMaximo: result['valorMaximo'],
        cidade: result['cidade'],
        negocio: result['negocio'],
        quartos: result['quartos'],
        banheiros: result['banheiros'],
        vagas: result['vagas'],
      );
      setState(() {});
    }
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
                              onPressed: filtro,
                              icon: Icon(Icons.filter_alt_outlined, color: Colors.black),
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
                            future: _imoveisFuture,
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
                                                          width: MediaQuery.of(context).size.width,
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