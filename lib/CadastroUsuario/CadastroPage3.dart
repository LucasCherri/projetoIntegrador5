import 'dart:io';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:front_projeto_quintoandar/FirstPage.dart';
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'dart:convert';
import '../Settings/Snackbar.dart';
import '../Settings/User.dart';
import 'package:intl/intl.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_widgets.dart';

class CadastroPage3 extends StatefulWidget {

  String nome, email, senha;

  CadastroPage3(this.nome, this.email, this.senha, {super.key});

  @override
  _CadastroPage3State createState() => _CadastroPage3State();
}

String generateToken() {
  var rng = Random.secure();
  var bytes = List<int>.generate(32, (i) => rng.nextInt(256));
  return base64Url.encode(bytes);
}

String token = generateToken();

class _CadastroPage3State extends State<CadastroPage3>{

  String buttonText = 'Concluir Cadastro';
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();
  User user = User("", "", "", "", "", "", "");
  String url = "http://192.168.15.165:8080/register";

  Future save() async {

    var db = await mongo.Db.create("mongodb+srv://lucascherri:lucascherri@cluster0.6udflvk.mongodb.net/authentication?retryWrites=true&w=majority");
    await db.open();
    var col = db.collection('user');

    var bytes = utf8.encode(widget.senha);
    var digest = sha256.convert(bytes);
    var senhaHash = digest.toString();

    user.senha = senhaHash;
    user.nome = widget.nome;
    user.email = widget.email;

    var res = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': user.email, 'senha': user.senha,
          'celular': user.celular, 'cpf': user.cpf, 'nome': user.nome, 'dataNasc': user.dataNasc}));

    print(res.body);

    var email = user.email;

    if (res.body != null) {
      dialog();
      final smtpServer = gmail('pi5triplex@gmail.com', 'zsamiktyuvykyigb');

      final message = Message()
        ..from = Address(email, 'Triplex - Confirmação de Email')
        ..recipients.add(email)
        ..subject = 'Novo cadastro'
        ..text = 'Olá ${user.nome}\nClique no link para confirmar o cadastro: http://seusite.com/confirmar?token=$token\nAtenciosamente, Equipe Triplex';

      await send(message, smtpServer);

      var doc = await col.findOne(mongo.where.eq('email', email));
      if (doc != null) {
        await col.update(mongo.where.eq('email', email), mongo.modify.set('confirmado', true));
      }
    }else{
      if(res.body == null){
        CustomSnackBarError(context, const Text('Este usuário já está cadastrado'));
      }
    }
  }

  void dialog(){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 5), () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => firstpage()),);
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
                  "Agradecemos por seu \ncadastro, um e-mail de \nconfirmação será \nenviado em breve.",
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

  Future _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1900),
        lastDate: new DateTime(2101)
    );
    if(picked != null) setState(() => user.dataNasc = DateFormat('dd/MM/yyyy').format(picked));

    final dataEscolhida = picked?.year.toInt();
    final dataAgora = DateTime.now().year;
    final verifica = dataAgora - dataEscolhida!;

    if(verifica < 18) {
      user.dataNasc = '';
      CustomSnackBarError(context, const Text('Você precisa ter mais de 18 anos'));
    }
  }

  void carregando() async {
    setState(() {
      isLoading = true;
      buttonText = 'Carregando...';
    });

    // Código para obter dados do banco de dados aqui
    await Future.delayed(Duration(seconds: 2)); // Simulação de tempo de espera

    setState(() {
      isLoading = false;
      buttonText = 'Concluir Cadastro';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Color(0xffF0F0F0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 30, right: 30, top: 50, bottom: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cadastro',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_circle_left_outlined,
                      size: 35
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CPF',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFDCE1EE),
                            border: Border.all(width: 1, color: Colors.black)
                        ),
                        child: TextFormField(
                          controller: TextEditingController(text: user.cpf),
                          onChanged: (val) {
                            user.cpf = val;
                          },
                          validator: (value) {
                            if (value!.isEmpty);
                            return null;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "000.000.000.00",
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [MaskedInputFormatter('###.###.###-##')],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Celular',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFDCE1EE),
                            border: Border.all(width: 1, color: Colors.black)
                        ),
                        child: TextFormField(
                          controller: TextEditingController(text: user.celular),
                          onChanged: (val) {
                            user.celular = val;
                          },
                          validator: (value) {
                            if (value!.isEmpty);
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "(00) 00000-0000",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                          ),
                          keyboardType: TextInputType.number,
                          autocorrect: false,
                          inputFormatters: [MaskedInputFormatter('(##)#####-####')],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Data de nascimento',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFDCE1EE),
                            border: Border.all(width: 1, color: Colors.black)
                        ),
                        child: TextFormField(
                          controller: TextEditingController(text: user.dataNasc),
                          onChanged: (val) {
                            user.dataNasc = val;
                          },
                          validator: (value) {
                            if (value!.isEmpty);
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "dd/mm/aaaa",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                          ),
                          readOnly: true,
                          onTap: (){
                            _selectDate();
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 40.0, 0.0, 0.0),
                        child: FFButtonWidget(
                          onPressed: () {
                            String cpf = user.cpf;
                            String cel = user.celular;
                            String dataNasc = user.dataNasc;
                            if(_formKey.currentState!.validate()){
                              if(cpf.isEmpty || cel.isEmpty || dataNasc.isEmpty){
                                CustomSnackBarError(context, const Text('Preecha todos os campos'));
                              }else{
                                if(cpf.length != 14){
                                  CustomSnackBarError(context, const Text('CPF inválido'));
                                }
                                if(cel.length != 14){
                                  CustomSnackBarError(context, const Text('Número de celular inválido'));
                                }
                              }
                              carregando();
                              save();
                            }
                          },
                          text: '$buttonText',
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
              )
            ],
          ),
        ),
      ),
    );
  }
}