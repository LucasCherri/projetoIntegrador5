import 'package:front_projeto_quintoandar/FirstPage.dart';

import '../SplashScreen.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

class NetErrorPage extends StatefulWidget {
  const NetErrorPage({Key? key}) : super(key: key);

  @override
  _NetErrorPageState createState() => _NetErrorPageState();
}

class _NetErrorPageState extends State<NetErrorPage> {

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFC1121F),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: AlignmentDirectional(0, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                  child: Image.asset(
                    'assets/no-internet.png',
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                    color: Colors.white,
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 10, 30, 0),
                  child: Text(
                    textAlign: TextAlign.center,
                    'Erro de conexão com a internet',
                    style: FlutterFlowTheme.of(context).bodyText1.override(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      color: Colors.white
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Container(
                margin: EdgeInsets.only(left: 40, right: 40),
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Splash()),);
                  },
                  label: Text('Tentar Novamente', style: TextStyle(color: Colors.black)),
                  icon: Icon(Icons.refresh_outlined, color: Colors.black),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(
                      color: Colors.black,
                      width: 3,
                    ),
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
