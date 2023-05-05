import 'package:flutter/material.dart';
import 'package:front_projeto_quintoandar/Settings/db.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<List<Map<String, dynamic>>?> getImoveis() async {
    var db = await Db.getConnectionImoveis();
    var col = db.collection('informacoes');
    final doc = await col.find().toList();

    List<Map<String, dynamic>>? data = doc;

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 30, right: 20),
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.list,
                      size: 30), onPressed: () {  },
                    )
                  ),
                  Container(
                    height: 550,
                      child: SizedBox(
                        child: FutureBuilder(
                            future: getImoveis(),
                            builder: (context, snapshot){
                              if(snapshot.hasData){
                                return ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index){
                                      return Align(
                                        alignment: AlignmentDirectional(0, 0),
                                        child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(10, 20, 10, 0),
                                          child: Container(
                                              width: double.infinity,
                                              margin: EdgeInsets.only(left: 20, right: 20),
                                              height: 300,
                                              decoration: BoxDecoration(
                                                color: Color(0xffF0F0F0),
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 2,
                                                    color: Colors.black,
                                                  )
                                                ],
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Container(
                                                      width: double.infinity,
                                                      height: 160,
                                                      decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius: BorderRadius.only(topRight: Radius.circular(8), topLeft: Radius.circular(8))
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                      EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.max,
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          Expanded(
                                                            child: Align(
                                                              alignment: AlignmentDirectional(-1, -1),
                                                              child: Text(
                                                                '${snapshot.data![index]['tipo']['tipo']}',
                                                                textAlign: TextAlign.start,
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Text('${snapshot.data![index]['valores']['negocio']}')
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.max,
                                                        children: [
                                                          Text(
                                                            '\n${snapshot.data![index]['endereco']['rua']}, ${snapshot.data![index]['endereco']['bairro']}'
                                                                '\n${snapshot.data![index]['endereco']['cidade']}(${snapshot.data![index]['endereco']['uf']})',
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.max,
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                              'Valor: R\$${snapshot.data![index]['valores']['valor']}'
                                                          ),
                                                          Icon(Icons.favorite_outline),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                          ),
                                        ),
                                      );
                                    }
                                );
                              }else{
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }
                        ),
                      )
                  ),
                ],
              )
          )
      ),
    );
  }
}