import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:front_projeto_quintoandar/CadastroImovel/CadastroImovelPage2.dart';
import 'package:front_projeto_quintoandar/Settings/FormData.dart';
import 'package:front_projeto_quintoandar/model/model_cadastroimovelpage1.dart';
import '../Settings/Navbar.dart';
import '../Settings/Snackbar.dart';
import '../flutter_flow/form_field_controller.dart';
import '../model/flutter_flow_model.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CadastroImovelPage1 extends StatefulWidget {

  Map<String, dynamic>? user;

  CadastroImovelPage1({Key? key, required this.user}) : super(key: key);

  @override
  _CadastroImovelPage1State createState() => _CadastroImovelPage1State();
}

class _CadastroImovelPage1State extends State<CadastroImovelPage1> {

  final scaffoldKey = GlobalKey<ScaffoldState>();
  late modelpage1 _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => modelpage1());

    _model.textController1 ??= TextEditingController();
    _model.textController2 ??= TextEditingController();
    _model.textController3 ??= TextEditingController();
    _model.textController4 ??= TextEditingController();
    _model.textController5 ??= TextEditingController();
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
                    'Cadastro de Imóvel - \nEndereço',
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

                          var doc = widget.user;

                          //Navigator.pop(context);
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => navbar(user: doc)),);
                        },
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-0.8, 0.0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                    child: Text(
                      'Rua',
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
                  alignment: AlignmentDirectional(-0.8, 0.0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                    child: Text(
                      'Bairro',
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
                    _model.textController2Validator.asValidator(context),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30.0, 20.0, 0.0, 0.0),
                  child: Container(
                    width: 337.0,
                    height: 100.0,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(0.05, 0.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    10.0, 0.0, 0.0, 0.0),
                                child: Text(
                                  'CEP',
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Poppins',
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 106.8,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xFFDCE1EE),
                                  border: Border.all(width: 2, color: Colors.black)
                              ),
                              child: TextFormField(
                                inputFormatters: [MaskedInputFormatter('#####-###')],
                                controller: _model.textController3,
                                obscureText: false,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 16),
                                ),
                                style: FlutterFlowTheme.of(context).bodyMedium,
                                validator: _model.textController3Validator
                                    .asValidator(context),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding:
                          EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    10.0, 0.0, 0.0, 0.0),
                                child: Text(
                                  'Número',
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Poppins',
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                              Container(
                                width: 100.3,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFFDCE1EE),
                                    border: Border.all(width: 2, color: Colors.black)
                                ),
                                child: TextFormField(
                                  controller: _model.textController4,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 16),
                                  ),
                                  style: FlutterFlowTheme.of(context).bodyMedium,
                                  validator: _model.textController4Validator
                                      .asValidator(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                          EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 30.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      10.0, 0.0, 0.0, 0.0),
                                  child: Text(
                                    'UF',
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Poppins',
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                              ),
                              FlutterFlowDropDown<String>(
                                controller: _model.dropDownValueController ??=
                                    FormFieldController<String>(null),
                                options: ['AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS', 'MG',
                                  'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO'],
                                onChanged: (val) =>
                                    setState(() => _model.dropDownValue = val),
                                width: 80.0,
                                height: 57.0,
                                searchHintTextStyle: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                  fontFamily: 'Poppins',
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                ),
                                textStyle:
                                FlutterFlowTheme.of(context).bodyMedium,
                                fillColor: Color(0xFFDCE1EE),
                                elevation: 2,
                                borderColor:
                                FlutterFlowTheme.of(context).primaryText,
                                borderWidth: 2.0,
                                borderRadius: 10.0,
                                margin: EdgeInsetsDirectional.fromSTEB(
                                    12.0, 4.0, 12.0, 4.0),
                                hidesUnderline: true,
                                isSearchable: false,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-0.8, 0.0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                    child: Text(
                      'Cidade',
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
                    controller: _model.textController5,
                    obscureText: false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium,
                    validator:
                    _model.textController5Validator.asValidator(context),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30.0, 20.0, 30.0, 0.0),
                  child: FFButtonWidget(
                    onPressed: () {
                      var rua = _model.textController1?.value.text;
                      var bairro = _model.textController2?.value.text;
                      var cep = _model.textController3?.value.text;
                      var numero = _model.textController4?.value.text;
                      var uf = _model.dropDownValueController?.value;
                      var cidade = _model.textController5?.value.text;

                      var formEndereco = FormEndereco(
                        rua: rua.toString(),
                        bairro: bairro.toString(),
                        cep: cep.toString(),
                        numero: numero.toString(),
                        uf: uf.toString(),
                        cidade: cidade.toString(),
                      );

                      var doc = widget.user;

                      if(rua == null || bairro == null || cep == null || numero == null || uf == null || cidade == null){
                        CustomSnackBarError(context, const Text('Preencha todos os campos'));
                      }else{
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CadastroImovelPage2(endereco:formEndereco, user: doc)));
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
