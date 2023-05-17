import 'package:front_projeto_quintoandar/model/model_cadastroimovelpage4.dart';
import 'package:image_picker/image_picker.dart';
import '../Settings/FormData.dart';
import '../model/flutter_flow_model.dart';
import '/flutter_flow/flutter_flow_checkbox_group.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'CadastroImovelPage5.dart';

class CadastroImovelPage4 extends StatefulWidget {
  final FormTipo tipo;
  final FormEndereco endereco;
  Map<String, dynamic>? user;
  List<String> imagens;

  CadastroImovelPage4({Key? key, required this.tipo, required this.endereco, this.user, required this.imagens}) : super(key: key);

  @override
  _CadastroImovelPage4State createState() =>
      _CadastroImovelPage4State();
}

class _CadastroImovelPage4State
    extends State<CadastroImovelPage4> {

  final scaffoldKey = GlobalKey<ScaffoldState>();
  late modelpage4 _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => modelpage4());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {

    _model.dispose();
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
                    'Cadastro de Imóvel - \nCaracterísticas',
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
                  alignment: AlignmentDirectional(0.05, -0.05),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(30.0, 10.0, 0.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Já Mobiliado',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Poppins',
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Padding(
                          padding:
                          EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 0.0, 0.0),
                          child: Switch(
                            value: _model.switchValue1 ??= true,
                            onChanged: (newValue) async {
                              setState(() => _model.switchValue1 = newValue);
                            },
                            activeColor: Color(0xFF003049),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 140,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(40.0, 0.0, 0.0, 0.0),
                      child: FlutterFlowCheckboxGroup(
                        options: [
                          'Armários na Cozinha',
                          'Armários no Quarto',
                          'Geladeira',
                          'Fogão',
                          'Ar Condicionado',
                          'Mesa de Jantar',
                          'Banheiro Equipado'
                        ],
                        onChanged: (val) =>
                            setState(() => _model.checkboxGroupValues = val),
                        controller: _model.checkboxGroupValueController ??=
                            FormFieldController<List<String>>(
                              [],
                            ),
                        activeColor: Color(0xFF003049),
                        checkColor: Colors.white,
                        checkboxBorderColor: FlutterFlowTheme.of(context).accent2,
                        textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Poppins',
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                        checkboxBorderRadius: BorderRadius.circular(4.0),
                        initialized: _model.checkboxGroupValues != null,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30.0, 15.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Quartos',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Poppins',
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(
                        padding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 0.0, 0.0),
                        child: Switch(
                          value: _model.switchValue2 ??= true,
                          onChanged: (newValue) async {
                            setState(() => _model.switchValue2 = newValue);
                          },
                          activeColor: Color(0xFF003049),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(-0.65, 0.0),
                      child: Text(
                        'Número de Quartos - ${_model.sliderValue1?.toStringAsFixed(0)}',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Poppins',
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsetsDirectional.fromSTEB(30.0, 0.0, 30.0, 0.0),
                      child: Container(
                        width: double.infinity,
                        child: Slider(
                          activeColor: Color(0xFF003049),
                          inactiveColor: FlutterFlowTheme.of(context).accent2,
                          min: 1,
                          max: 6,
                          value: _model.sliderValue1 ??= 1,
                          label: _model.sliderValue1?.toStringAsFixed(0),
                          divisions: 5,
                          onChanged: (newValue) {
                            newValue = double.parse(newValue.toStringAsFixed(0));
                            setState(() => _model.sliderValue1 = newValue);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30.0, 0.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Banheiros',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Poppins',
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(
                        padding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 0.0, 0.0),
                        child: Switch(
                          value: _model.switchValue3 ??= true,
                          onChanged: (newValue) async {
                            setState(() => _model.switchValue3 = newValue);
                          },
                          activeColor: Color(0xFF003049),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(-0.65, 0.0),
                      child: Text(
                        'Número de Banheiros - ${_model.sliderValue2?.toStringAsFixed(0)}',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Poppins',
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsetsDirectional.fromSTEB(30.0, 0.0, 30.0, 0.0),
                      child: Container(
                        width: double.infinity,
                        child: Slider(
                          activeColor: Color(0xFF003049),
                          inactiveColor: FlutterFlowTheme.of(context).accent2,
                          min: 1,
                          max: 6,
                          value: _model.sliderValue2 ??= 1,
                          label: _model.sliderValue2?.toStringAsFixed(0),
                          divisions: 5,
                          onChanged: (newValue) {
                            newValue = double.parse(newValue.toStringAsFixed(0));
                            setState(() => _model.sliderValue2 = newValue);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30.0, 0.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Vagas para Carros',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Poppins',
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(
                        padding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 0.0, 0.0),
                        child: Switch(
                          value: _model.switchValue4 ??= true,
                          onChanged: (newValue) async {
                            setState(() => _model.switchValue4 = newValue);
                          },
                          activeColor: Color(0xFF003049),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(-0.65, 0.0),
                      child: Text(
                        'Número de Vagas - ${_model.sliderValue3?.toStringAsFixed(0)}',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Poppins',
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsetsDirectional.fromSTEB(30.0, 0.0, 30.0, 0.0),
                      child: Container(
                        width: double.infinity,
                        child: Slider(
                          activeColor: Color(0xFF003049),
                          inactiveColor: FlutterFlowTheme.of(context).accent2,
                          min: 1,
                          max: 6,
                          value: _model.sliderValue3 ??= 1,
                          label: _model.sliderValue3?.toStringAsFixed(0),
                          divisions: 5,
                          onChanged: (newValue) {
                            newValue = double.parse(newValue.toStringAsFixed(0));
                            setState(() => _model.sliderValue3 = newValue);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30.0, 0.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Aceita Pets',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Poppins',
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(
                        padding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 0.0, 0.0),
                        child: Switch(
                          value: _model.switchValue5 ??= true,
                          onChanged: (newValue) async {
                            setState(() => _model.switchValue5 = newValue);
                          },
                          activeColor: Color(0xFF003049),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30.0, 20.0, 30.0, 0.0),
                  child: FFButtonWidget(
                    onPressed: () {

                      bool? switchMobilias = _model.switchValue1;
                      List<String>? mobilias = _model.checkboxGroupValueController?.value?.toList();
                      bool? switchQuartos = _model.switchValue2;
                      var numeroQuartos = _model.sliderValue1?.toStringAsFixed(0);
                      bool? switchBanheiros = _model.switchValue3;
                      var numeroBanheiros = _model.sliderValue2?.toStringAsFixed(0);
                      bool? switchVagas = _model.switchValue4;
                      var numeroVagas = _model.sliderValue3?.toStringAsFixed(0);
                      bool? switchPets = _model.switchValue5;

                      if(switchQuartos == false){
                        numeroQuartos = 0.toString();
                      }else{
                        numeroQuartos = _model.sliderValue1.toString();
                      }
                      if(switchBanheiros == false){
                        numeroBanheiros = 0.toString();
                      }else{
                        numeroBanheiros = _model.sliderValue2.toString();
                      }
                      if(switchVagas == false){
                        numeroVagas = 0.toString();
                      }else{
                        numeroVagas = _model.sliderValue3.toString();
                      }
                      if(switchPets == false){
                        switchPets == false;
                      }else{
                        switchPets == true;
                      }

                      var formCaracteristicas = FormCaracteristicas(
                          switchMobilias: switchMobilias as bool,
                          mobilias: mobilias ?? [],
                          switchQuartos: switchQuartos as bool,
                          numeroQuartos: numeroQuartos.toString(),
                          switchBanheiros: switchBanheiros as bool,
                          numeroBanheiros: numeroBanheiros.toString(),
                          switchVagas: switchVagas as bool,
                          numeroVagas: numeroVagas.toString(),
                          switchPets: switchPets as bool,
                      );

                      var tipo = widget.tipo;
                      var endereco = widget.endereco;
                      var doc = widget.user;

                      List<String> imagens = widget.imagens;

                      Navigator.push(context, MaterialPageRoute(builder: (context) => CadastroImovelPage5(tipo: tipo, endereco: endereco, caracteristicas: formCaracteristicas, user: doc, imagens: imagens)));
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
                        fontSize: 18.0,
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
