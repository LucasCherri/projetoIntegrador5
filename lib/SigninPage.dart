import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:front_projeto_quintoandar/RedefinirSenhaPage.dart';
import 'package:front_projeto_quintoandar/Settings/Navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Settings/Snackbar.dart';
import 'Settings/User.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<void> _handleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('Usuário não autenticado');
        return;
      }

      final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
      // Aqui você pode salvar as informações do usuário no MongoDB
      print(googleUser);
    } catch (error) {
      print(error);
    }
  }


  final _formKey = GlobalKey<FormState>();
  User user = User("", "", "", "", "", "", "");
  String url = "http://172.16.12.128:8080/login";

  Future login() async {

    var db = await mongo.Db.create("mongodb+srv://lucascherri:lucascherri@cluster0.6udflvk.mongodb.net/authentication?retryWrites=true&w=majority");
    await db.open();
    var col = db.collection('user');

    var bytes = utf8.encode(user.senha);
    var digest = sha256.convert(bytes);
    var senhaHash = digest.toString();

    user.senha = senhaHash;

    var res = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': user.email, 'senha': user.senha, 'celular': user.celular, 'cpf': user.cpf, 'nome': user.nome, 'dataNasc': user.dataNasc}));
    print(res.body.length);

    var email = user.email;
    var doc = await col.findOne(mongo.where.eq('email', email));
    var confirmado = doc!['confirmado'];

    if(res.body.length < 1000){
      if(confirmado != null){
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', email);

        Navigator.push(context,MaterialPageRoute(builder: (context) => new navbar(user: doc)));
      }else{
        CustomSnackBarError(context, const Text('Cadastro não confirmado'));
      }
    }else if(res.body.length > 1000){
      CustomSnackBarError(context, const Text('Email ou senha incorretos'));
    }
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
                'Login',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close,
                size: 30),
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
                  'E-mail',
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
                    controller: TextEditingController(text: user.email),
                    onChanged: (val) {
                      user.email = val;
                    },
                    validator: (value) {
                      if (value!.isEmpty);
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Senha',
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
                    controller: TextEditingController(text: user.senha),
                    onChanged: (val) {
                      user.senha = val;
                    },
                    validator: (value) {
                      if (value!.isEmpty);
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                      child: Text(
                        'Esqueceu sua senha?',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(context,MaterialPageRoute(builder: (context) => RedefinirSenha()));
                      },
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async{
                      String email = user.email;
                      String senha = user.senha;
                      if(_formKey.currentState!.validate()){
                        if(email.isEmpty || senha.isEmpty){
                          CustomSnackBarError(context, const Text('Preecha todos os campos'));
                        }else{
                          login();
                        }
                      }
                    },
                    label: Text('Entrar'),
                    icon: Icon(Icons.login),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF003049),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Ou entre com',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      color: Colors.blue,
                      iconSize: 40,
                      icon: Icon(Icons.facebook),
                      onPressed: () {},
                    ),
                    SizedBox(width: 20),
                    IconButton(
                      color: Colors.red,
                      iconSize: 45,
                      icon: Icon(Icons.g_mobiledata),
                      onPressed: () {
                        _handleSignIn();
                      },
                    ),
                  ],
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