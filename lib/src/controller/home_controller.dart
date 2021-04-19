import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:free_chat/src/network/database_handler.dart';
import 'package:free_chat/src/network/invite.dart';
import 'package:free_chat/src/network/networking.dart';
import 'package:free_chat/src/utils/logger.dart';
import 'package:free_chat/src/view.dart';

import '../model.dart';

class HomeController {

  static final HomeController _homeController = HomeController._internal();

  final Logger _logger = Logger("HomeController");

  Node _currentNode;

  SSKKey _sskKey;

  factory HomeController() {
    return _homeController;
  }


  Networking networking = new Networking();

  HomeController._internal();


  Future<void> initNode() async {
    _currentNode = await networking.connectClient();

    DatabaseHandler().fetchAllChats().then((value) => {
      for(ChatDTO chat in value) {
        networking.update(chat)
      }
    });
  }

  Future<void> invite(BuildContext context) async {
    Invite invite = Invite();
    DatabaseHandler _databaseHandler = DatabaseHandler();

    invite.setClient(ChatClient(_sskKey, "Dennis"));

    String identifier = Uuid().v4();

    LoadingPopupWithProgressCall.build(context, "Creating chat room, this can take up to a couple minutes", [identifier]);

    InitialInvite inv = await invite.createInitialInvitation(identifier);

    Navigator.pop(context);

    HomeInvitePopup.build(context, inv);

  }

  Future<void> join(BuildContext context) async {
    /*Networking networking = Networking();
    SSKKey key = await networking.getKeys();

    String data = "{txt: 3}\n";

    var put = FcpClientPut(key.getAsUskInsertUri() + "test.txt/0/", data, priorityClass: 1, filename: "test.txt", global: true, persistence: Persistence.forever, metaDataContentType: "text/plain", identifier: Uuid().v4(), dataLength: data.length);

    print(key.getAsUskInsertUri() + "test.txt/0/");

    networking.fcpConnection.sendFcpMessage(put);
    */
    var i = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeJoin()),
    );

    var invite = jsonDecode(i);
    var initialInvite = InitialInvite.fromJson(invite);

    String identifier1 = Uuid().v4();
    String identifier2 = Uuid().v4();
    String identifier3 = Uuid().v4();

    LoadingPopupWithProgressCall.build(context, "Joining chat room this can take up to a couple minutes", [identifier1, identifier2, identifier3]);

    await Invite().handleInvitation(initialInvite, identifier1, identifier2, identifier3);

    Navigator.pop(context);



  }

  Future<void> update() async {

    //InitialInvite initialInvite = InitialInvite.fromJson(jsonDecode('{"requestUri": "USK@NYU78JteGVdK-DzU2jC04tm~HSOdBmVqWOiQkp8kFb8,wdYBH7gef1Iz8sikL6siIjsmOr2cFlTv6zQ1STHTffg,AQACAAE/chat.json/0/", "handshakeUri": "KSK@bca38c4f-df09-4f11-8545-b619c4c4b87b", "name": "Dennis", "encryptKey": "f53e3efa-dc0f-49a9-a8c5-53938a29c086"}'));

    //await Invite().inviteAccepted(initialInvite);

    var list = await DatabaseHandler().fetchAllChats();
    for(var dto in list) {
      print(dto.requestUri);
    }

  }

  String getTextForButton() {
    if(_currentNode == null) {
      return "Not connected to Node";
    }
    String text = "Name: ${_currentNode.getNodeName()}"
        "\nVersion: ${_currentNode.getVersion()}"
        "\nFcpVersion: ${_currentNode.getFcpVersion()}"
        "\nBuild: ${_currentNode.getBuild()}\n"
        "Connected: ${_currentNode.isConnected()}";
    return text;

  }


}

/*
    Chat chat = Chat("asd", "asd", "asd", [], "karl");

    ChatDTO dto = ChatDTO.fromChat(chat);

    //dto = await _databaseHandler.upsertChat(ChatDTO.fromChat(chat));

    dto = await _databaseHandler.fetchChatByRequestUri("asd");

    _logger.i(dto.id.toString());

    var timestamp = formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn]);

    Message msg = Message("hallo" , timestamp, "Test");
    Message msg1 = Message("hallo" , timestamp, "Test2");
    MessageDTO messageDTO = MessageDTO.fromMessage(msg);
    MessageDTO messageDTO2 = MessageDTO.fromMessage(msg1);

    messageDTO.chatId = dto.id;
    messageDTO2.chatId = dto.id;

    MessageDTO mDto = await _databaseHandler.upsertMessage(messageDTO);
    await _databaseHandler.upsertMessage(messageDTO);
    await _databaseHandler.upsertMessage(messageDTO2);
    await _databaseHandler.upsertMessage(messageDTO2);
    Chat chatfetch = await _databaseHandler.fetchChatAndMessages(dto.id);
    _logger.i((await _databaseHandler.fetchAllChats()).toString());

 */