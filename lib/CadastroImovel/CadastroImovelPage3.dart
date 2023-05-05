import 'dart:convert';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:front_projeto_quintoandar/CadastroImovel/CadastroImovelPage4.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../Settings/FormData.dart';
import '../Settings/db.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:io';

class CadastroImovelPage3 extends StatefulWidget {
  final FormTipo tipo;
  final FormEndereco endereco;
  Map<String, dynamic>? user;

  CadastroImovelPage3({Key? key, required this.tipo, required this.endereco, this.user}) : super(key: key);

  @override
  _CadastroImovelPage3State createState() => _CadastroImovelPage3State();
}

class _CadastroImovelPage3State extends State<CadastroImovelPage3> {

  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<XFile> fotosSelecionadas = [];
  List<XFile> fotosTiradas = [];

  selecionarFotos() async {
    final ImagePicker picker = ImagePicker();

    try {
      XFile? file = await picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        setState(() {
          if (fotosSelecionadas == null) {
            fotosSelecionadas = [file];
          } else {
            fotosSelecionadas.add(file);
          }
        });
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  tirarFotos() async {
    final ImagePicker picker = ImagePicker();

    try {
      XFile? file = await picker.pickImage(source: ImageSource.camera);
      if (file != null) {
        setState(() {
          if (fotosTiradas == null) {
            fotosTiradas = [file];
          } else {
            fotosTiradas.add(file);
          }
        });
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 60, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Cadastro de Imóvel - \nFotos',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Poppins',
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      FlutterFlowIconButton(
                        borderColor: Colors.transparent,
                        borderRadius: 30,
                        borderWidth: 1,
                        buttonSize: 60,
                        icon: FaIcon(
                          FontAwesomeIcons.arrowAltCircleLeft,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 30,
                        ),
                        onPressed: () {
                          print('IconButton pressed ...');
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 60, 30, 0),
                  child: FFButtonWidget(
                    onPressed: () async{
                      tirarFotos();
                    },
                    text: 'Tirar Fotos',
                    icon: Icon(
                      Icons.photo_camera_outlined,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 15,
                    ),
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 61,
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: Color(0xFFEAE2B7),
                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Poppins',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 18,
                      ),
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primaryText,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10 , right: 40),
                  child: ListTile(
                    trailing: fotosTiradas != null && fotosTiradas.isNotEmpty
                        ? SizedBox(
                      width: 250.0,
                      height: 150.0,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: fotosTiradas.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: SizedBox(
                              width: 100,
                              height: 200,
                              child: Stack(
                                children: [
                                  InkWell(
                                    child: Image.file(
                                      File(fotosTiradas[index].path),
                                      width: 100,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                    onTap: (){
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            child: Container(
                                              width: 300,
                                              height: 300,
                                              child: Image.file(
                                                File(fotosTiradas[index].path),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          fotosTiradas.removeAt(index);
                                        });
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        child: const Icon(Icons.close),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                        : null,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 20, 30, 0),
                  child: FFButtonWidget(
                    onPressed: () {
                      selecionarFotos();
                    },
                    text: 'Escolher Fotos da Galeria',
                    icon: Icon(
                      Icons.photo_library_outlined,
                      size: 15,
                    ),
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 61,
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: Color(0xFFEAE2B7),
                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Poppins',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 18,
                      ),
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primaryText,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10 , right: 40),
                  child: ListTile(
                    trailing: fotosSelecionadas != null && fotosSelecionadas.isNotEmpty
                        ? SizedBox(
                      width: 250.0,
                      height: 150.0,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: fotosSelecionadas.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: SizedBox(
                              width: 100,
                              height: 200,
                              child: Stack(
                                children: [
                                  InkWell(
                                    child: Image.file(
                                      File(fotosSelecionadas[index].path),
                                      width: 100,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                    onTap: (){
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            child: Container(
                                              width: 300,
                                              height: 300,
                                              child: Image.file(
                                                File(fotosSelecionadas[index].path),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          fotosSelecionadas.removeAt(index);
                                        });
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        child: const Icon(Icons.close),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                        : null,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 40, 30, 0),
                  child: FFButtonWidget(
                    onPressed: () {
                      var tipo = widget.tipo;
                      var endereco = widget.endereco;
                      var doc = widget.user;

                      Navigator.push(context, MaterialPageRoute(builder: (context) => CadastroImovelPage4(tipo: tipo, endereco: endereco, user: doc)));
                    },
                    text: 'Continuar',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 61,
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
