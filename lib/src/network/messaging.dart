import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:free_chat/src/fcp/fcp.dart';
import 'package:free_chat/src/model.dart';
import 'package:free_chat/src/network/database_handler.dart';
import 'package:free_chat/src/network/networking.dart';
import 'package:free_chat/src/utils/logger.dart';

class Messaging extends ChangeNotifier {
  static final Messaging _messaging = Messaging._internal();

  final Logger _logger = Logger("Messaging");

  final Networking _networking = Networking();

  final DatabaseHandler _databaseHandler = DatabaseHandler();

  final Codec<String, String> stringToBase64 = utf8.fuse(base64);

  factory Messaging() {
    return _messaging;
  }

  Messaging._internal();

  Future<void> sendMessage(ChatDTO chat, Message message) async {

    MessageDTO messageDTO = MessageDTO.fromMessage(message);
    messageDTO.chatId = chat.id;
    messageDTO.messageTyp = "sender";

    await _databaseHandler.upsertMessage(messageDTO);

    var messages = (await _databaseHandler.fetchChatAndMessages(chat.id)).messages;

    Chat _chat = Chat.fromDTO(chat, messages);

    _networking.sendMessage(chat.insertUri, _chat.toString(), Uuid().v4()).then((value) {
      _logger.i("Send Message Successful");
      messageDTO.status = "send";
      _databaseHandler.upsertMessage(messageDTO).then((value) => notifyListeners());

    });
  }

  Future<void> updateChat(FcpMessage fcpMessage, String requestUri) async {

    String json = stringToBase64.decode(fcpMessage.data);
    Chat chat = Chat.fromJson(jsonDecode(json), requestUri);

    ChatDTO chatDTO = await _databaseHandler.fetchChatBySharedId(chat.sharedId);

    print(chat.toString());
    print(json);
    for(var db in await _databaseHandler.fetchAllChats()) {
      print(db.sharedId);
    }

    updateMessages(chatDTO, chat);

  }


  Future<ChatDTO> updateMessages(ChatDTO chatDTO, Chat newChat) async {
    List<String> updated = [];
    var oldChat = await _databaseHandler.fetchChatAndMessages(chatDTO.id);
    for(Message msg in newChat.messages) {
      bool flag = false;
      for(Message msg2 in oldChat.messages) {
        if(msg.message == msg2.message && msg.getTimestamp() == msg2.getTimestamp()) {
          flag = true;
          break;
        }
      }
      String checkString = msg.message + msg.messageType + msg.getTimestamp() + msg.sender;
      if(!flag && !updated.contains(checkString)) {
        updated.add(checkString);
        MessageDTO messageDTO = MessageDTO.fromMessage(msg);
        messageDTO.messageTyp = "receiver";
        messageDTO.chatId = chatDTO.id;
        messageDTO.status = "received";
        await _databaseHandler.upsertMessage(messageDTO);
        notifyListeners();
      }
    }


  }
}