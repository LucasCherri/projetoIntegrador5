import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

import 'Settings/Snackbar.dart';

class RedefinirSenha extends StatefulWidget {
  @override
  _RedefinirSenhaState createState() => _RedefinirSenhaState();
}

class _RedefinirSenhaState extends State<RedefinirSenha> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerUpdateSenha = TextEditingController();
  TextEditingController controllerCodigoVerificacao = TextEditingController();

  late String codigo;

  String codigoRedefinicao(){
    Random random = Random();
    int numero = random.nextInt(999999);
    codigo = numero.toString().padLeft(6, '0');

    return codigo;
  }

  Future emailRedefinicao()async{

    var email = controllerEmail.text;

    final smtpServer = gmail('pi5triplex@gmail.com', 'zsamiktyuvykyigb');

    final message = Message()
      ..from = Address(email, 'Triplex - Código para redefinição de senha')
      ..recipients.add(email)
      ..subject = 'Código para redefinir senha'
      ..text = 'Código:${codigoRedefinicao()}\nAtenciosamente, Equipe Triplex';

    await send(message, smtpServer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF0F0F0),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 50, bottom: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Redefina sua \nsenha',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Email',
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
                    color: Color(0xFFCED6E0),
                    border: Border.all(width: 1, color: Colors.black)
                ),
                child: TextFormField(
                  controller: controllerEmail,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'Nova senha',
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
                    color: Color(0xFFCED6E0),
                    border: Border.all(width: 1, color: Colors.black)
                ),
                child: TextFormField(
                  controller: controllerUpdateSenha,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async{
                    var db = await mongo.Db.create("mongodb+srv://lucascherri:lucascherri@cluster0.6udflvk.mongodb.net/authentication?retryWrites=true&w=majority");
                    await db.open();
                    var col = db.collection('user');

                    var email = controllerEmail.text;
                    var senhaNova = controllerUpdateSenha.text;

                    var bytes = utf8.encode(senhaNova);
                    var digest = sha256.convert(bytes);
                    var senhaHash = digest.toString();

                    var doc = await col.findOne(mongo.where.eq('email', email));
                    if(email.isEmpty || senhaNova.isEmpty){
                      CustomSnackBarError(context, const Text('Preencha todos os campos'));
                    }else{
                      if(doc == null){
                        CustomSnackBarError(context, const Text('Email inválido'));
                      }else{
                        emailRedefinicao();
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              scrollable: true,
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
                                      "Enviamos um email \ncom um código de \nverificação para \nredefinição de senha",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      'Código de verificação',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      margin: EdgeInsets.only(left: 20, right: 20),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Color(0xFFCED6E0),
                                          border: Border.all(width: 1, color: Colors.black)
                                      ),
                                      child: TextFormField(
                                        controller: controllerCodigoVerificacao,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 16),
                                        ),
                                        textAlign: TextAlign.center,
                                        inputFormatters: [MaskedInputFormatter('######')],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                                      child: ElevatedButton.icon(
                                        onPressed: (){
                                          if(controllerCodigoVerificacao.text.isEmpty){
                                            CustomSnackBarError(context, const Text('Preecha o código de verificação'));
                                          }else{
                                            if(controllerCodigoVerificacao.text == codigo){
                                              col.updateOne(mongo.where.eq('email', email), mongo.modify.set('senha', senhaHash));
                                              CustomSnackBarSucess(context, const Text('Senha redefinida com sucesso'));
                                              Navigator.pop(context);
                                            }else{
                                              CustomSnackBarError(context, const Text('Código de verificação inválido'));
                                            }
                                          }
                                        },
                                        icon: Icon(Icons.check),
                                        label: Text('Concluir'),
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xFF003049),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          padding: EdgeInsets.symmetric(vertical: 16),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    }
                  },
                  icon: Icon(Icons.check),
                  label: Text('Concluir'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF003049),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
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
