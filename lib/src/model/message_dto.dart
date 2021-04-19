import 'package:free_chat/src/model.dart';
import 'package:free_chat/src/model/chat_dto.dart';

class MessageDTO {
  MessageDTO();

  int id;
  String _message;
  String _timestamp;
  String _sender;
  int chatId;
  ChatDTO chat;
  String messageTyp;

  get message => _message;
  get timestamp => _timestamp;
  get sender => _sender;

  static final columns = ["id", "message", "timestamp", "chatId", "sender", "messageType"];

  Map toMap() {
    Map<String, Object> map = {
      "message": _message,
      "timestamp": _timestamp,
      "chatId": chatId,
      "sender": sender,
      "messageType": messageTyp
    };

    if (id != null) {
    map["id"] = id;
    }

    return map;
  }

  static fromMap(Map map) {
    MessageDTO messageDTO = new MessageDTO();
    messageDTO.id = map["id"];
    messageDTO._message = map["message"];
    messageDTO._timestamp = map["timestamp"];
    messageDTO.chatId = map["chatId"];
    messageDTO._sender = map["sender"];
    messageDTO.messageTyp = map["messageType"];

    return messageDTO;
  }

  static fromMessage(Message message) {
    MessageDTO messageDTO = new MessageDTO();
    messageDTO._message = message.getMessage();
    messageDTO._timestamp = message.getTimestamp();
    messageDTO._sender = message.sender;

    return messageDTO;
  }
}
