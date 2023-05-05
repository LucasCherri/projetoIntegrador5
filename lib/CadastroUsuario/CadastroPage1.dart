import 'package:flutter/material.dart';
import 'package:front_projeto_quintoandar/CadastroUsuario/CadastroPage2.dart';

class CadastroPage1 extends StatefulWidget {
  @override
  _CadastroPage1State createState() => _CadastroPage1State();
}

class _CadastroPage1State extends State<CadastroPage1> {
  String _selectedOption = 'Quero alugar/comprar um imóvel';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF0F0F0),
      body: Container(
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
                    'Cadastro',
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
            SizedBox(height: 50),
            Text(
              'Você deseja?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Colors.black),
                color: Color(0xFFCED6E0),
              ),
              child: DropdownButton<String>(
                value: _selectedOption,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedOption = newValue!;
                  });
                },
                items: <String>[
                  'Quero alugar/comprar um imóvel',
                  'Tenho um imóvel a ser alugado/vendido',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(value),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context) => CadastroPage2()));
                },
                icon: Icon(Icons.arrow_forward),
                label: Text('Continuar'),
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
  }
}
