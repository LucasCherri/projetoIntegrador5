import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zego_zimkit/services/services.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF003049),
        title: Text("Mensagens"),
        actions: [
          PopupMenuButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)
              ),
              position: PopupMenuPosition.under,
              icon: Icon(CupertinoIcons.add_circled),
              itemBuilder: (context){
                return [PopupMenuItem(
                  value: "Nova Conversa",
                  child: ListTile(
                    leading: Icon(CupertinoIcons.chat_bubble_2_fill,
                        color: Colors.black),
                    title: Text("Nova Conversa", maxLines: 1,),
                  ),
                  onTap: (){
                    ZIMKit().showDefaultNewPeerChatDialog(context);
                  },
                )];
              })
        ],
      ),
      body: ZIMKitConversationListView(
        onPressed: (context, conversation, defaultAction){
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return ZIMKitMessageListPage(conversationID: conversation.id,
              conversationType: conversation.type,);
          }));
        },
      ),
    );
  }
}
