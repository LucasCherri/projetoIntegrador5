import 'package:flutter/material.dart';
import 'package:front_projeto_quintoandar/SigninPage.dart';
import 'package:front_projeto_quintoandar/CadastroUsuario/CadastroPage1.dart';
import 'package:front_projeto_quintoandar/flutter_flow/flutter_flow_theme.dart';
import 'package:front_projeto_quintoandar/flutter_flow/flutter_flow_widgets.dart';

class firstpage extends StatefulWidget {
  const firstpage({Key? key}) : super(key: key);

  @override
  State<firstpage> createState() => _firstpageState();
}

class _firstpageState extends State<firstpage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Color(0xCD669BBC),
        body: Stack(
          children: [
            Container(
                padding: EdgeInsets.only(left: 35, top: 130),
                child: Row(
                  children: [
                    Text(
                      "Seja Bem-Vindo(a)",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                      ),
                    ),
                  ],
                )
            ),
            Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 35, right: 35),
                    child: Column(
                      children: [
                        FFButtonWidget(
                          onPressed: () {
                            Navigator.push(context,MaterialPageRoute(builder: (context) => LoginPage()));
                          },
                          text: 'Entrar',
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 60,
                            color: Color(0xFFEAE2B7),
                            textStyle: FlutterFlowTheme.of(context)
                                .subtitle2
                                .override(
                              fontFamily: 'Poppins',
                              color: Colors.black,
                            ),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FFButtonWidget(
                          onPressed: () {
                            Navigator.push(context,MaterialPageRoute(builder: (context) => CadastroPage1()));
                          },
                          text: 'Cadastrar',
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 60,
                            color: Color(0xFFEAE2B7),
                            textStyle: FlutterFlowTheme.of(context)
                                .subtitle2
                                .override(
                              fontFamily: 'Poppins',
                              color: Colors.black,
                            ),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
