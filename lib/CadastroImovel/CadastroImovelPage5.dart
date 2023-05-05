import 'package:front_projeto_quintoandar/Settings/FormData.dart';
import 'package:front_projeto_quintoandar/Settings/Navbar.dart';
import 'package:objectid/objectid.dart';

import '../Settings/db.dart';
import '../flutter_flow/form_field_controller.dart';
import '../model/flutter_flow_model.dart';
import '../model/model_cadastroimovelpage5.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CadastroImovelPage5 extends StatefulWidget {
  final FormTipo tipo;
  final FormEndereco endereco;
  final FormCaracteristicas caracteristicas;
  Map<String, dynamic>? user;

  CadastroImovelPage5({Key? key, required this.tipo, required this.endereco, required this.caracteristicas, this.user}) : super(key: key);

  @override
  _CadastroImovelPage5State createState() => _CadastroImovelPage5State();
}

class _CadastroImovelPage5State extends State<CadastroImovelPage5> {

  final scaffoldKey = GlobalKey<ScaffoldState>();
  late modelpage5 _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => modelpage5());

    _model.textController1 ??= TextEditingController();
    _model.textController2 ??= TextEditingController();
    _model.textController3 ??= TextEditingController();
    _model.textController4 ??= TextEditingController();
  }

  @override
  void dispose() {

    _model.dispose();
    super.dispose();
  }

  void dialog(){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 5), () {
          var doc = widget.user;
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => navbar(user: doc)),);
        });

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 80,
                ),
                SizedBox(height: 10),
                Text(
                  "Sucesso!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Seu imóvel foi cadastrado com sucesso",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Text(
                  "Você será redirecionado em \n5 segundos",
                  style: TextStyle(fontSize: 12,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
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
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 60.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Cadastro de Imóvel - \nValores',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Poppins',
                          fontSize: 26.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      FlutterFlowIconButton(
                        borderColor: Colors.transparent,
                        borderRadius: 30.0,
                        borderWidth: 1.0,
                        buttonSize: 60.0,
                        icon: FaIcon(
                          FontAwesomeIcons.arrowAltCircleLeft,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 30.0,
                        ),
                        onPressed: () {
                          print('IconButton pressed ...');
                        },
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-0.7, 0.0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 40.0, 0.0, 0.0),
                    child: Text(
                      'Tipo de negócio',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Poppins',
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30.0, 0.0, 30.0, 0.0),
                  child: FlutterFlowDropDown<String>(
                    controller: _model.dropDownValueController ??=
                        FormFieldController<String>(null),
                    options: ['Alugar', 'Comprar'],
                    onChanged: (val) =>
                        setState(() => _model.dropDownValue = val),
                    width: double.infinity,
                    height: 50.0,
                    searchHintTextStyle:
                    FlutterFlowTheme.of(context).bodyLarge.override(
                      fontFamily: 'Poppins',
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                    textStyle: FlutterFlowTheme.of(context).bodyMedium,
                    searchHintText: 'Search for an item...',
                    fillColor: Color(0xFFCED6E0),
                    elevation: 2.0,
                    borderColor: FlutterFlowTheme.of(context).primaryText,
                    borderWidth: 2.0,
                    borderRadius: 10.0,
                    margin: EdgeInsetsDirectional.fromSTEB(12.0, 4.0, 12.0, 4.0),
                    hidesUnderline: true,
                    isSearchable: false,
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-0.7, 0.0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                    child: Text(
                      'Valor do Aluguel',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Poppins',
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30.0, 0.0, 30.0, 0.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFFCED6E0),
                        border: Border.all(width: 2, color: Colors.black)
                    ),
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
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(35.0, 20.0, 35.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Valor de condomínio',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Poppins',
                          fontSize: 18.0,
                        ),
                      ),
                      Padding(
                        padding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 0.0, 0.0),
                        child: Switch(
                          value: _model.switchValue1 ??= true,
                          onChanged: (newValue) async {
                            setState(() => _model.switchValue1 = newValue!);
                          },
                          activeColor: Color(0xFF003049),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30.0, 0.0, 30.0, 0.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFFCED6E0),
                        border: Border.all(width: 2, color: Colors.black)
                    ),
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
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(35.0, 20.0, 35.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Valor do IPTU',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Poppins',
                          fontSize: 18.0,
                        ),
                      ),
                      Padding(
                        padding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 0.0, 0.0),
                        child: Switch(
                          value: _model.switchValue2 ??= true,
                          onChanged: (newValue) async {
                            setState(() => _model.switchValue2 = newValue!);
                          },
                          activeColor: Color(0xFF003049),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30.0, 0.0, 30.0, 0.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFFCED6E0),
                        border: Border.all(width: 2, color: Colors.black)
                    ),
                    child: TextFormField(
                      controller: _model.textController3,
                      obscureText: false,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium,
                      validator:
                      _model.textController3Validator.asValidator(context),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(35.0, 20.0, 35.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Valor de seguro para \nincêndios',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Poppins',
                          fontSize: 18.0,
                        ),
                      ),
                      Padding(
                        padding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 0.0, 0.0),
                        child: Switch(
                          value: _model.switchValue3 ??= true,
                          onChanged: (newValue) async {
                            setState(() => _model.switchValue3 = newValue!);
                          },
                          activeColor: Color(0xFF003049),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30.0, 0.0, 30.0, 0.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFFCED6E0),
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
                      validator:
                      _model.textController4Validator.asValidator(context),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 40.0, 0.0, 0.0),
                  child: FFButtonWidget(
                    onPressed: () async{

                      var negocio = _model.dropDownValueController?.value;
                      var valor = _model.textController1?.value.text;
                      bool? switchValorCond = _model.switchValue1;
                      var valorCond = _model.textController2?.value.text;
                      bool? switchValorIPTU = _model.switchValue2;
                      var valorIPTU = _model.textController3?.value.text;
                      bool? switchValorSeguro = _model.switchValue3;
                      var valorSeguro = _model.textController4?.value.text;

                      if(switchValorCond == false){
                        valorCond = 0.toString();
                      }else{
                        valorCond = _model.textController2?.value.text;
                      }
                      if(switchValorIPTU == false){
                        valorIPTU = 0.toString();
                      }else{
                        valorIPTU = _model.textController3?.value.text;
                      }
                      if(switchValorSeguro == false){
                        valorSeguro = 0.toString();
                      }else{
                        valorSeguro = _model.textController4?.value.text;
                      }

                      var valores = FormValores(
                          negocio: negocio.toString(),
                          valor: valor.toString(),
                          switchValorCond: switchValorCond as bool,
                          valorCond: valorCond.toString(),
                          switchValorIPTU: switchValorIPTU as bool,
                          valorIPTU: valorIPTU.toString(),
                          switchValorSeguro: switchValorSeguro as bool,
                          valorSeguro: valorSeguro.toString(),
                      );

                      var endereco = widget.endereco;
                      var tipo = widget.tipo;
                      var carac = widget.caracteristicas;
                      
                      var db = await Db.getConnectionImoveis();
                      var col = db.collection('informacoes');

                      var user = widget.user;
                      var id = user!['_id'];

                      col.insertOne({
                        '_userId': id,
                        'endereco': {
                          'rua': endereco.rua,
                          'bairro': endereco.bairro,
                          'cep': endereco.cep,
                          'cidade': endereco.cidade,
                          'numero': endereco.numero,
                          'uf': endereco.uf
                        },
                        'tipo': {
                          'tipo': tipo.tipo,
                          'tamanho': tipo.tamanho,
                          'titulo': tipo.titulo
                        },
                        'caracteristicas': {
                          'numeroQuartos': carac.numeroQuartos,
                          'numeroBanheiros': carac.numeroBanheiros,
                          'numeroVagas': carac.numeroVagas,
                          'switchPets': carac.switchPets,
                          'mobilias': carac.mobilias
                        },
                        'valores': {
                          'valorSeguro': valores.valorSeguro,
                          'valor': valores.valor,
                          'valorIPTU': valores.valorIPTU,
                          'valorCond': valores.valorCond,
                          'negocio': valores.negocio
                        }
                      });
                      dialog();
                    },
                    text: 'Concluir Cadastro',
                    options: FFButtonOptions(
                      width: 337.0,
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
      ),
    );
  }
}
