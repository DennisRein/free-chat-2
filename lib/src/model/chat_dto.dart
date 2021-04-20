import 'dart:collection';

import '../model.dart';

class ChatDTO {
  ChatDTO();

  String insertUri;
  String requestUri;
  String encryptKey;
  String name;
  String sharedId;
  int id;

  static final columns = ["id", "insertUri", "requestUri", "encryptKey", "name", "sharedId"];

  Map<String, Object> toMap() {
    Map<String, Object> map = {
      "insertUri": insertUri,
      "requestUri": requestUri,
      "encryptKey": encryptKey,
      "name": name,
      "sharedId": sharedId
    };

    if (id != null) {
      map["id"] = id;
    }

    return map;
  }

  static fromMap(Map map) {
    ChatDTO chat = new ChatDTO();
    chat.id = map["id"];
    chat.requestUri = map["requestUri"];
    chat.insertUri= map["insertUri"];
    chat.encryptKey= map["encryptKey"];
    chat.name = map["name"];
    chat.sharedId = map["sharedId"];

    return chat;
  }

  static fromChat(Chat chat) {
    ChatDTO chatDTO = new ChatDTO();
    chatDTO.requestUri = chat.requestUri;
    chatDTO.insertUri= chat.insertUri;
    chatDTO.encryptKey= chat.encryptKey;
    chatDTO.name = chat.name;
    chatDTO.sharedId = chat.sharedId;

    return chatDTO;
  }
}