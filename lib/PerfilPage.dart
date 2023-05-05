import 'dart:convert';

import 'package:front_projeto_quintoandar/CadastroImovel/CadastroImovelPage1.dart';
import 'package:front_projeto_quintoandar/SuaContaPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'FirstPage.dart';
import 'Settings/Snackbar.dart';
import 'Settings/db.dart';
import 'flutter_flow/flutter_flow_widgets.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class PerfilPage extends StatefulWidget {

  Map<String, dynamic>? user;

  PerfilPage({Key? key, required this.user}) : super(key: key);

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _scrollController = ScrollController();
  int _currentPage = 1;
  int _pageSize = 3;
  List<Map<String, dynamic>> _imoveis = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Future<List<Map<String, dynamic>>> getImoveis(int page, int pageSize) async {

    var user = widget.user;
    var id = user!['_id'];

    var db = await Db.getConnectionImoveis();
    var col = db.collection('informacoes');
    final doc = col.find(mongo.where.eq('_userId', id)).skip((page - 1) * pageSize).take(pageSize).toList();

    List<Map<String, dynamic>> data = await doc;

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

  void seusImoveis() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          body: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                          margin: EdgeInsets.only(right: 20),
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(Icons.close,
                                size: 30),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                      ),
                      Container(
                          height: 600,
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
                                            Text("Carregando seus imóveis...")
                                          ],
                                        ));
                                  }
                                  if (snapshot.hasError) {
                                    return Center(child: Text('Error: ${snapshot.error}'));
                                  }
                                  if (!snapshot.hasData) {
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
                                                            Text('${_imoveis[index]['valores']['negocio']}')
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.max,
                                                          children: [
                                                            Text(
                                                              '\n${_imoveis[index]['endereco']['rua']},\n${_imoveis[index]['endereco']['bairro']},'
                                                                  '\n${_imoveis[index]['endereco']['cidade']} - ${_imoveis[index]['endereco']['uf']}',
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
                                                                'Valor: R\$ ${_imoveis[index]['valores']['valor']}'
                                                            ),
                                                            InkWell(
                                                              child: Icon(
                                                                Icons.delete_outline,
                                                              ),
                                                              onTap: (){
                                                                showDialog(
                                                                  context: context,
                                                                  builder: (BuildContext context) {
                                                                    return AlertDialog(
                                                                      title: Text("Apagar anúncio"),
                                                                      content: Text("Deseja apagar esse anúncio?"),
                                                                      actions: [
                                                                        TextButton(
                                                                          child: Text("Cancelar"),
                                                                          onPressed:  () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                        ),
                                                                        TextButton(
                                                                          child: Text("Sim"),
                                                                          onPressed:  () async{
                                                                            var db = await Db.getConnectionImoveis();
                                                                            var col = db.collection('informacoes');
                                                                            await col.remove(_imoveis[index]);
                                                                            setState(() {
                                                                              _imoveis .removeAt(index);
                                                                            });
                                                                            Navigator.pop(context);
                                                                            CustomSnackBarSucess(context, const Text('Anúncio apagado com sucesso'));
                                                                          },
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                            )
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
      },
    );
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
                          text: 'Visitas Marcadas',
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
    var doc = widget.user;
    var nome = doc!['nome'];
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Color(0xFF2D7298),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        child: Container(
                          width: 80,
                          height: 80,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF003049)
                          ),
                          child: Icon(
                            Icons.person_outline,
                            color: FlutterFlowTheme.of(context).lineColor,
                            size: 40,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  nome,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                    fontFamily: 'Poppins',
                                    color: FlutterFlowTheme.of(context).lineColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: AlignmentDirectional(0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  InkWell(
                                    child: Align(
                                      alignment: AlignmentDirectional(0, 0),
                                      child: Text(
                                        'Gerencie sua conta',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                            fontFamily: 'Poppins',
                                            color: FlutterFlowTheme.of(context)
                                                .lineColor,
                                            fontSize: 14,
                                            decoration: TextDecoration.underline
                                        ),
                                      ),
                                    ),
                                    onTap: (){
                                      var doc = widget.user;
                                      Navigator.push(context,MaterialPageRoute(builder: (context) => new SuaContaPage(user: doc)));
                                    },
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        5, 0, 0, 0),
                                    child: FaIcon(
                                      FontAwesomeIcons.edit,
                                      color:
                                      FlutterFlowTheme.of(context).lineColor,
                                      size: 14,
                                    ),
                                  ),
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
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(30, 0, 0, 0),
                        child: Text(
                          'Para comprar ou alugar',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Poppins',
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(60, 0, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              color: Colors.black,
                              size: 18,
                            ),
                            InkWell(
                              child: Padding(
                                padding:
                                EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                                child: Text(
                                  'Visitas',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        indent: 60,
                        endIndent: 30,
                        color: Color(0x7E57636C),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(60, 0, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(
                              Icons.assignment_outlined,
                              color: Colors.black,
                              size: 18,
                            ),
                            InkWell(
                              child: Padding(
                                padding:
                                EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                                child: Text(
                                  'Propostas',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        indent: 60,
                        endIndent: 30,
                        color: Color(0x7E57636C),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(60, 0, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(
                              Icons.settings_outlined,
                              color: Colors.black,
                              size: 18,
                            ),
                            InkWell(
                              child: Padding(
                                padding:
                                EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                                child: Text(
                                  'Configurar Alertas',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        indent: 60,
                        endIndent: 30,
                        color: Color(0x7E57636C),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(60, 0, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(
                              Icons.notifications_none,
                              color: Colors.black,
                              size: 18,
                            ),
                            InkWell(
                              child: Padding(
                                padding:
                                EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                                child: Text(
                                  'Notificações',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        indent: 60,
                        endIndent: 30,
                        color: Color(0x7E57636C),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(30, 10, 0, 0),
                        child: Text(
                          'Anuncie seu imóvel',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Poppins',
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(60, 0, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.format_list_bulleted,
                              color: Colors.black,
                              size: 18,
                            ),
                            InkWell(
                              child: Padding(
                                padding:
                                EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                                child: Text(
                                  'Anunciar Imóvel',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              onTap: ()async{
                                var doc = widget.user;
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CadastroImovelPage1(user: doc)),);
                              },
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        indent: 60,
                        endIndent: 30,
                        color: Color(0x7E57636C),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(60, 0, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.home_outlined,
                              color: Colors.black,
                              size: 18,
                            ),
                            InkWell(
                              child: Padding(
                                padding:
                                EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                                child: Text(
                                  'Gerenciar seus Anúncios',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              onTap: (){
                                seusImoveis();
                              },
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        indent: 60,
                        endIndent: 30,
                        color: Color(0x7E57636C),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(60, 0, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              color: Colors.black,
                              size: 18,
                            ),
                            InkWell(
                              child: Padding(
                                padding:
                                EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                                child: Text(
                                  'Calendário de Visitas',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        indent: 60,
                        endIndent: 30,
                        color: Color(0x7E57636C),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(30, 0, 0, 0),
                        child: Text(
                          'Mais opções',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Poppins',
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(60, 0, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.help_outline,
                              color: Colors.black,
                              size: 18,
                            ),
                            InkWell(
                              child: Padding(
                                padding:
                                EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                                child: Text(
                                  'Ajuda',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        indent: 60,
                        endIndent: 30,
                        color: Color(0x7E57636C),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(60, 0, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(
                              Icons.lock_outlined,
                              color: Colors.black,
                              size: 18,
                            ),
                            InkWell(
                              child: Padding(
                                padding:
                                EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                                child: Text(
                                  'Termos e Privacidade',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        indent: 60,
                        endIndent: 30,
                        color: Color(0x7E57636C),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(60, 0, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(
                              Icons.logout,
                              color: Colors.black,
                              size: 18,
                            ),
                            InkWell(
                              child: Padding(
                                padding:
                                EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                                child: Text(
                                  'Sair',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              onTap: ()async{
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.remove('_id');
                                Navigator.push(context,MaterialPageRoute(builder: (context) => firstpage()));
                              },
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        indent: 60,
                        endIndent: 30,
                        color: Color(0x7E57636C),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}
