import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:front_projeto_quintoandar/CadastroUsuario/CadastroPage3.dart';
import '../Settings/Snackbar.dart';
import '../Settings/User.dart';
import 'package:email_validator/email_validator.dart';

class CadastroPage2 extends StatefulWidget {
  const CadastroPage2({Key? key}) : super(key: key);

  @override
  _CadastroPage2State createState() => _CadastroPage2State();
}

class _CadastroPage2State extends State<CadastroPage2>{

  final _formKey = GlobalKey<FormState>();
  User user = User("", "", "", "", "", "", "");

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
                padding: EdgeInsets.only(left: 20, top: 50, bottom: 50),
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
                      icon: Icon(Icons.arrow_circle_left_outlined),
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
                        'Nome',
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
                          controller: TextEditingController(text: user.nome),
                          onChanged: (val) {
                            user.nome = val;
                          },
                          validator: (value) {
                            if (value!.isEmpty);
                            return null;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20),
                          ),
                          inputFormatters: [MaskedInputFormatter('#################')],
                        ),
                      ),
                      SizedBox(height: 20),
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
                          controller: TextEditingController(text: user.email),
                          onChanged: (val) {
                            user.email = val;
                          },
                          validator: (value) {
                            if (value!.isEmpty);
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "exemplo@exemplo.com",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20),
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
                            color: Color(0xFFCED6E0),
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
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            String nome = user.nome;
                            String email = user.email;
                            String senha = user.senha;

                            final bool isValid = EmailValidator.validate(email);
                            if(_formKey.currentState!.validate()){
                              if(nome.isEmpty || email.isEmpty || senha.isEmpty){
                                CustomSnackBarError(context, const Text('Preecha todos os campos'));
                              }else{
                                if(isValid){
                                  Navigator.push(context,MaterialPageRoute(builder: (context) => CadastroPage3(nome, email, senha)));
                                }else{
                                  if (isValid == false){
                                    CustomSnackBarError(context, const Text('Email inválido'));
                                  }else{
                                    CustomSnackBarError(context, const Text('Este email já está cadastrado'));
                                  }
                                }
                              }
                            }
                          },
                          label: Text('Continuar'),
                          icon: Icon(Icons.arrow_forward),
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
                            'Ou faça cadastro com',
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