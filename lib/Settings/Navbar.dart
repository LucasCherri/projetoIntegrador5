import 'package:flutter/material.dart';
import 'package:front_projeto_quintoandar/ChatPage.dart';
import 'package:front_projeto_quintoandar/FavoritosPage.dart';
import 'package:front_projeto_quintoandar/PerfilPage.dart';
import '../HomePage.dart';
import '../flutter_flow/flutter_flow_theme.dart';

class navbar extends StatefulWidget {

  Map<String, dynamic>? user;

  navbar({Key? key, required this.user}) : super(key: key);

  @override
  _navbarState createState() => _navbarState();
}

class _navbarState extends State<navbar> {

  final scaffoldKey = GlobalKey<ScaffoldState>();

  int _indiceAtual = 0;

  late var doc = widget.user;

  late List<Widget> _telas = [
    HomePage(),
    FavoritosPage(),
    ChatPage(),
    PerfilPage(user: doc)
  ];

  void onTabTapped(int index) {
    setState(() {
      _indiceAtual = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _telas[_indiceAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        onTap: onTabTapped,
        selectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, color: Colors.black),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline, color: Colors.black),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline, color: Colors.black),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, color: Colors.black),
            label: 'Perfil',
          ),
        ],
      ),
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
    );
  }
}
