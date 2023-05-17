import 'package:front_projeto_quintoandar/Settings/FormData.dart';
import 'package:front_projeto_quintoandar/model/model_cadastroimovelpage2.dart';
import '../Settings/Snackbar.dart';
import '../model/flutter_flow_model.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'CadastroImovelPage3.dart';

class CadastroImovelPage2 extends StatefulWidget {
  final FormEndereco endereco;
  Map<String, dynamic>? user;

  CadastroImovelPage2({Key? key, required this.endereco, this.user}) : super(key: key);

  @override
  _CadastroImovelPage2State createState() => _CadastroImovelPage2State();
}

class _CadastroImovelPage2State extends State<CadastroImovelPage2> {

  final scaffoldKey = GlobalKey<ScaffoldState>();
  late modelpage2 _model;

  late String informacaoSelecionada;
  bool botao1Selecionado = false;
  bool botao2Selecionado = false;
  bool botao3Selecionado = false;
  bool botao4Selecionado = false;

  @override
  void initState() {
    super.initState();

    _model = createModel(context, () => modelpage2());

    _model.textController1 ??= TextEditingController();
    _model.textController2 ??= TextEditingController();
  }

  @override
  void dispose() {

    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  height: 100,
                  decoration: BoxDecoration(
                    color: Color(0xFF003049),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Cadastro de Imóvel - \nTipo de Imóvel',
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
                Align(
                  alignment: AlignmentDirectional(-0.65, 0.0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                    child: Text(
                      'Título do Anúncio',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Poppins',
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFDCE1EE),
                      border: Border.all(width: 2, color: Colors.black)
                  ),
                  margin: EdgeInsets.only(left: 30, right: 30),
                  child: TextFormField(
                    controller: _model.textController1,
                    obscureText: false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium,
                    validator:
                    _model.textController1Validator.asValidator(context),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-0.7, 0.0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                    child: Text(
                      'Tipo de Imóvel',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Poppins',
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30.0, 0.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FFButtonWidget(
                        onPressed: () {
                          setState((){
                            informacaoSelecionada = "Kitnet";
                            botao1Selecionado = true;
                            botao2Selecionado = false;
                            botao3Selecionado = false;
                            botao4Selecionado = false;
                          });
                        },
                        text: 'Kitnet',
                        options: FFButtonOptions(
                          width: 80.0,
                          height: 40.0,
                          padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                          iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                          color: botao1Selecionado ? Color(0xFF003049) : Color(0xFFDCE1EE),
                          textStyle: FlutterFlowTheme.of(context)
                              .titleSmall
                              .override(
                            fontFamily: 'Poppins',
                            color: botao1Selecionado ? Colors.white : Colors.black,
                          ),
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primaryText,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      Padding(
                        padding:
                        EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                        child: FFButtonWidget(
                          onPressed: () {
                            setState((){
                              informacaoSelecionada = "Apartamento";
                              botao1Selecionado = false;
                              botao2Selecionado = true;
                              botao3Selecionado = false;
                              botao4Selecionado = false;
                            });
                          },
                          text: 'Apartamento',
                          options: FFButtonOptions(
                            width: 130.0,
                            height: 40.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: botao2Selecionado ? Color(0xFF003049) : Color(0xFFDCE1EE),
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                              fontFamily: 'Poppins',
                              color: botao2Selecionado ? Colors.white : Colors.black,
                            ),
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primaryText,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                        EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                        child: FFButtonWidget(
                          onPressed: () {
                            setState((){
                              informacaoSelecionada = "Casa";
                              botao1Selecionado = false;
                              botao2Selecionado = false;
                              botao3Selecionado = true;
                              botao4Selecionado = false;
                            });
                          },
                          text: 'Casa',
                          options: FFButtonOptions(
                            width: 80.0,
                            height: 40.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: botao3Selecionado ? Color(0xFF003049) : Color(0xFFDCE1EE),
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                              fontFamily: 'Poppins',
                              color: botao3Selecionado ? Colors.white : Colors.black,
                            ),
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primaryText,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-0.7, 0.0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                    child: FFButtonWidget(
                      onPressed: () {
                        setState((){
                          informacaoSelecionada = "Casa de Condomínio";
                          botao1Selecionado = false;
                          botao2Selecionado = false;
                          botao3Selecionado = false;
                          botao4Selecionado = true;
                        });
                      },
                      text: 'Casa de Condomínio',
                      options: FFButtonOptions(
                        width: 160.0,
                        height: 40.0,
                        padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: botao4Selecionado ? Color(0xFF003049) : Color(0xFFDCE1EE),
                        textStyle:
                        FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Poppins',
                          color: botao4Selecionado ? Colors.white : Colors.black,
                        ),
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).primaryText,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-0.7, 0.0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                    child: Text(
                      'Tamanho (m2)',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Poppins',
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFDCE1EE),
                      border: Border.all(width: 2, color: Colors.black)
                  ),
                  margin: EdgeInsets.only(left: 30, right: 30),
                  child: TextFormField(
                    controller: _model.textController2,
                    obscureText: false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium,
                    validator:
                    _model.textController1Validator.asValidator(context),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30.0, 40.0, 30.0, 0.0),
                  child: FFButtonWidget(
                    onPressed: () {
                      var titulo = _model.textController1?.value.text;
                      var tamanho = _model.textController2?.value.text;
                      var tipoImovel = informacaoSelecionada;

                      var formTipo = FormTipo(
                        titulo: titulo.toString(),
                        tamanho: tamanho.toString(),
                        tipo: tipoImovel.toString(),
                      );

                      var endereco = widget.endereco;
                      var doc = widget.user;

                      if(titulo == null || tamanho == null || tipoImovel == null){
                        CustomSnackBarError(context, const Text('Preencha todos os campos'));
                      }else{
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CadastroImovelPage3(tipo: formTipo, endereco: endereco, user: doc)));
                      }
                    },
                    text: 'Continuar',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 61.0,
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: Color(0xFF003049),
                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                      ),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}
