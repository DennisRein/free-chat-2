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
    var i = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeJoin()),
    );
    var initialInvite;

    try {
      initialInvite = InitialInvite.fromBase64(i);
    }
    catch(e) {
      return null;
    }

    String identifier1 = Uuid().v4();
    String identifier2 = Uuid().v4();
    String identifier3 = Uuid().v4();

    LoadingPopupWithProgressCall.build(context, "Joining chat with ${initialInvite.getName()} this can take up to a couple minutes", [identifier1, identifier2, identifier3]);

    await Invite().handleInvitation(initialInvite, identifier1, identifier2, identifier3);

    Navigator.pop(context);
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