import 'package:flutter/material.dart';
import 'package:zego_zimkit/services/services.dart';
import 'ChatScreen.dart';

class ChatPage extends StatefulWidget {

  Map<String, dynamic>? user;

  ChatPage({Key? key, required this.user}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  @override
  Widget build(BuildContext context) {
    var doc = widget.user;
    var email = doc!['email'];
    var name = doc['nome'];

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 40, right: 30, left: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Suas Conversas", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 30,),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFDCE1EE),
                  border: Border.all(width: 1, color: Colors.black)
              ),
              child: TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    hintText: email
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFDCE1EE),
                  border: Border.all(width: 1, color: Colors.black)
              ),
              child: TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 20, vertical: 16),
                  hintText: name
                ),
              ),
            ),
            SizedBox(height: 30,),
            Container(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async{
                  await ZIMKit().connectUser(id: email, name: name);
                  Navigator.push(context,MaterialPageRoute(builder: (context) => new ChatScreen()));
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
          ],
        ),
      ),
    );
  }
}
