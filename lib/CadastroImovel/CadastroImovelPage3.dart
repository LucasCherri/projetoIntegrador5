import 'dart:convert';
import 'dart:typed_data';
import 'package:front_projeto_quintoandar/CadastroImovel/CadastroImovelPage4.dart';
import 'package:image_picker/image_picker.dart';
import '../Settings/FormData.dart';
import '../Settings/Snackbar.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

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
  List<String> fotosSelecionadasBase64 = [];

  selecionarFotos() async {
    final ImagePicker picker = ImagePicker();

    try {
      XFile? file = await picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        List<int> bytes = await file.readAsBytes();
        String base64Image = base64Encode(bytes);
        setState(() {
          if (fotosSelecionadasBase64 == null) {
            fotosSelecionadasBase64 = [base64Image];
          } else {
            fotosSelecionadasBase64.add(base64Image);
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
        List<int> bytes = await file.readAsBytes();
        List<int> compressedBytes = await FlutterImageCompress.compressWithList(
          Uint8List.fromList(bytes),
          minHeight: 600, // ajuste conforme necessário
          minWidth: 800, // ajuste conforme necessário
          quality: 55, // ajuste conforme necessário
          format: CompressFormat.jpeg, // ajuste conforme necessário
        );
        String base64Image = base64Encode(compressedBytes);
        setState(() {
          if (fotosSelecionadasBase64 == null) {
            fotosSelecionadasBase64 = [base64Image];
          } else {
            fotosSelecionadasBase64.add(base64Image);
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
                Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Color(0xFF003049),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Cadastro de Imóvel - \nFotos',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Poppins',
                      color: FlutterFlowTheme.of(context).lineColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
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
                          Navigator.pop(context);
                          //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => navbar(user: doc)),);
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 20, 30, 0),
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
                    trailing: fotosSelecionadasBase64 != null && fotosSelecionadasBase64.isNotEmpty
                        ? SizedBox(
                      width: 250.0,
                      height: 150.0,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: fotosSelecionadasBase64.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: SizedBox(
                              width: 100,
                              height: 200,
                              child: Stack(
                                children: [
                                  InkWell(
                                    child: Image.memory(
                                      base64Decode(fotosSelecionadasBase64[index]),
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
                                              child: Image.memory(
                                                base64Decode(fotosSelecionadasBase64[index]),
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
                                          fotosSelecionadasBase64.removeAt(index);
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
                    onPressed: () async{

                      var tipo = widget.tipo;
                      var endereco = widget.endereco;
                      var doc = widget.user;

                      List<String> imagens = fotosSelecionadasBase64;

                      if(fotosSelecionadasBase64.isEmpty){
                        CustomSnackBarError(context, const Text('Adicione fotos para o seu anúncio ficar melhor'));
                      }else{
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CadastroImovelPage4(tipo: tipo, endereco: endereco, user: doc, imagens: imagens)));
                      }
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
