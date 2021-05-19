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
    InitialInvite initialInvite;

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

    var invitationResponse = await Invite().handleInvitation(initialInvite, identifier1, identifier2, identifier3);
    //var invitationResponse = InitialInviteResponse("test", "test");

    _logger.i(invitationResponse.toString());

    if(invitationResponse != null) {
      Navigator.pop(context);
      HomeJoinPopup.build(context, invitationResponse);
    }
    else {
      Navigator.pop(context);
      ErrorPopup.build(context, "An error occured while trying to join the chat room, please try again later");

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