import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:free_chat/src/controller/chat_controller.dart';
import 'package:free_chat/src/fcp/fcp.dart';
import 'package:free_chat/src/model.dart';
import 'package:free_chat/src/network/database_handler.dart';
import 'package:free_chat/src/network/messaging.dart';

class ChatsDetail extends StatefulWidget {
  Chat chat;
  ChatDTO chatDTO;

  ChatsDetail(this.chat, this.chatDTO);

  @override
  _ChatsDetailState createState() => _ChatsDetailState();
}

class _ChatsDetailState extends State<ChatsDetail> {
  ChatController _chatController = ChatController();
  final inputFieldController = TextEditingController();
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    Messaging().addListener(() {
      if(!mounted)
        return;

      setState(() {

      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var messages = widget.chat.messages;

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          widget.chat.name,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Stack(children: <Widget>[
          Stack(
            children: <Widget>[
              FutureBuilder(
                  future:
                      DatabaseHandler().fetchChatAndMessages(widget.chatDTO.id),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return Container(
                        child: Center(
                          child: Text('Loading'),
                        ),
                      );
                    }
                    messages = snapshot.data.messages;
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: messages.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 10, bottom: 50),
                      itemBuilder: (context, index) {
                        return Container(
                            padding: EdgeInsets.only(
                                left: 14, right: 14, top: 10, bottom: 10),
                            child: Align(
                              alignment:
                                  (messages[index].messageType == "receiver"
                                      ? Alignment.topLeft
                                      : Alignment.topRight),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color:
                                          (messages[index].messageType == "receiver"
                                              ? Colors.grey.shade200
                                              : Colors.blue[200]),
                                    ),
                                    padding: EdgeInsets.all(16),
                                    child: Text(
                                      messages[index].message,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  Text(messages[index].getTimestamp()),
                                  Text(messages[index].status),
                                ],
                              ),
                            ));
                      },
                    );
                  }),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  height: 60,
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TextField(
                          controller: inputFieldController,
                          decoration: InputDecoration(
                              hintText: "Write message...",
                              hintStyle: TextStyle(color: Colors.black54),
                              border: InputBorder.none),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      FloatingActionButton(
                        onPressed: () async {
                          await _chatController.sendMessage(
                              widget.chatDTO, inputFieldController.text);
                          inputFieldController.text = "";
                          setState(() {});
                          _scrollController.animateTo(
                            0.0,
                            curve: Curves.easeOut,
                            duration: const Duration(milliseconds: 300),
                          );
                        },
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 18,
                        ),
                        backgroundColor: Colors.blue,
                        elevation: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ]));
  }
}
