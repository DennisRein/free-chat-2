/*
            {
                "id": "xxx",
                "nextURI": "xxx",
                "users": [{
                    "name": "",
                    "public": ""
                }],
                "messages" : [{
                    "message": "",
                    "sendBy": "",
                    "timestamp": ""
                }]
            }
 */
import 'dart:convert';

import 'package:free_chat/src/model.dart';

class Chat {
  String _insertUri;
  String _requestUri;
  String _encryptKey;
  String _with;
  String sharedId;
  List<Message> _messages;

  get insertUri => _insertUri;
  get requestUri => _requestUri;
  get encryptKey => _encryptKey;
  get name => _with;

  get messages => _messages;

  Chat(this._insertUri, this._requestUri, this._encryptKey, this._messages, this._with, this.sharedId);

  factory Chat.fromDTO(ChatDTO dto, List<Message> messages) {
    return Chat(dto.insertUri, dto.requestUri, dto.encryptKey, messages, dto.name, dto.sharedId);
  }

  factory Chat.fromJson(dynamic json, String requestUri) {
    List messages = json["messages"];
    var parsedMessages = messages.map((e) => Message.fromJson(e)).toList();


    return Chat.onlyInfo(
      json["with"],
      parsedMessages,
      requestUri,
      json["sharedId"]
    );
  }

  void addMessage(Message message) {
    this._messages.add(message);
  }

  Map<String, dynamic> toMap() {
    return {
      'insertUri': _insertUri,
      'requestUri': _requestUri,
      'encryptKey': _encryptKey,
      'with': _with,
      'sharedId': sharedId
    };
  }

  Chat.onlyInfo(this._with, this._messages, this._requestUri, this.sharedId);

  List<User> getUsers() {
    //return this._users;
  }

  List<Message> getMessages() {
    return this._messages;
  }

  String getNextUri() {
    return this.getNextUri();
  }

  @override
  String toString() {

    //String users = propertyToJsonListString(_users);
    String messages = propertyToJsonListString(_messages);


    return '{"sharedId": "$sharedId", "with": "$_with", "messages": $messages}';

  }

  String propertyToJsonListString(List<dynamic> property) {
    if(property.length == 0) return "[]";
    String propertyString = "[";
    property.forEach((element) {
      propertyString = propertyString + element.toString() + ",";
    });
    if (propertyString != null && propertyString.length > 0) {
      propertyString = propertyString.substring(0, propertyString.length - 1);
    }
    propertyString = propertyString + "]";
    return propertyString;
  }
}
