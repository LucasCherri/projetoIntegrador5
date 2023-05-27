import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:http/http.dart' as http;
import 'FirstPage.dart';
import 'Settings/Snackbar.dart';
import 'Settings/User.dart';
import 'Settings/db.dart';

class SuaContaPage extends StatefulWidget {

  Map<String, dynamic>? user;

  SuaContaPage({Key? key, required this.user}) : super(key: key);

  @override
  _SuaContaPageState createState() => _SuaContaPageState();
}

class _SuaContaPageState extends State<SuaContaPage> {

  final scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController controllerNome = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerCelular = TextEditingController();
  TextEditingController controllerCPF = TextEditingController();
  TextEditingController controllerDataNasc = TextEditingController();

  User user = User("", "", "", "", "", "", "");

  String url = "http://192.168.15.165:8080/delete";

  void delete() async {
    await http.post(Uri.parse(url));
  }

  openAlertBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: 300.0,
              height: 200.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Exclusão de Conta",
                        style: TextStyle(fontSize: 24.0),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 4.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: TextEditingController(text: user.email),
                      onChanged: (val) {
                        user.email = val;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Email está em branco')),
                          );
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        icon: const Icon(
                          FontAwesomeIcons.envelope,
                          color: Colors.black,
                        ),
                        hintText: 'Email',
                        hintStyle: const TextStyle(
                            fontFamily: 'WorkSansSemiBold', fontSize: 16.0),
                      ),
                    ),
                  ),
                  TextButton(
                    child: const Text('Apagar'),
                    onPressed: () {
                      if (user.email.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Email está em branco')),
                        );
                      } else {
                        var doc = widget.user;
                        var email = doc!['email'];
                        if (email == user.email) {
                          delete();
                          Navigator.push(context, MaterialPageRoute(builder: (
                              context) => firstpage()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Email incorreto')),
                          );
                        }
                      }
                    },
                  ),
                  TextButton(
                    child: const Text('Cancelar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
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
    var doc = widget.user;
    var nome = doc!['nome'];
    var cel = doc['celular'];
    var cpf = doc['cpf'];
    var email = doc['email'];
    var dataNasc = doc['dataNasc'];

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
                  alignment: AlignmentDirectional(-0.75, 0.8),
                  child: Text(
                    'Sua Conta',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Poppins',
                      color: FlutterFlowTheme.of(context).lineColor,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 30, 0),
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
                        },
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-0.8, 0),
                  child: Text(
                    'Nome',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFFDCE1EE),
                        border: Border.all(width: 2, color: Colors.black)
                    ),
                    child: TextFormField(
                      controller: controllerNome,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: nome,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                      ),
                      inputFormatters: [MaskedInputFormatter('#################')],
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-0.8, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: Text(
                      'Celular',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFFDCE1EE),
                        border: Border.all(width: 2, color: Colors.black)
                    ),
                    child: TextFormField(
                      controller: controllerCelular,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: cel,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                      ),
                      inputFormatters: [MaskedInputFormatter('(##)#####-####')],
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-0.8, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: Text(
                      'Email',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFFDCE1EE),
                        border: Border.all(width: 2, color: Colors.black)
                    ),
                    child: TextFormField(
                      controller: controllerEmail,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: email,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                      ),
                      readOnly: true,
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-0.8, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: Text(
                      'CPF',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFFDCE1EE),
                        border: Border.all(width: 2, color: Colors.black)
                    ),
                    child: TextFormField(
                      controller: controllerCPF,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: cpf,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                      ),
                      readOnly: true,
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-0.65, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: Text(
                      'Data de Nascimento',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFFDCE1EE),
                        border: Border.all(width: 2, color: Colors.black)
                    ),
                    child: TextFormField(
                      controller: controllerDataNasc,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: dataNasc,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                      ),
                      readOnly: true,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 40, 30, 0),
                  child: FFButtonWidget(
                    onPressed: () async{

                      var doc = widget.user;
                      var email = doc!['email'];
                      var nome = controllerNome.text;
                      var cel = controllerCelular.text;

                      var db = await Db.getConnection();
                      var col = db.collection('user');

                      if(nome.isNotEmpty && cel.isEmpty){
                        col.updateOne(mongo.where.eq('email', email), mongo.modify.set('nome', nome));
                        CustomSnackBarSucess(context, const Text('Nome atualizado com sucesso'));
                      }else if(cel.isNotEmpty && nome.isEmpty){
                        col.updateOne(mongo.where.eq('email', email), mongo.modify.set('celular', cel));
                        CustomSnackBarSucess(context, const Text('Celular atualizado com sucesso'));
                      }else if(nome.isNotEmpty && cel.isNotEmpty){
                        col.updateOne(mongo.where.eq('email', email), mongo.modify.set('nome', nome).set('celular', cel));
                        CustomSnackBarSucess(context, const Text('Nome e Celular atualizados com sucesso'));
                      }else{
                        CustomSnackBarError(context, const Text('Preencha os campos que deseja atualizar'));
                      }
                    },
                    text: 'Salvar',
                    options: FFButtonOptions(
                      width: 337,
                      height: 61,
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: Color(0xFF003049),
                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                      ),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                InkWell(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                    child: Text(
                      'Deletar sua Conta',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Poppins',
                        color: FlutterFlowTheme.of(context).error,
                      ),
                    ),
                  ),
                  onTap: (){
                    openAlertBox();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
