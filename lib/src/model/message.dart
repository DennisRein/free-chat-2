import 'package:free_chat/src/model.dart';

class Message {
  String _message;
  String _timestamp;
  String _sender;
  String _messageType;
  String status;

  Message(this._message, this._timestamp, this._sender, this._messageType, this.status);

  get messageType => _messageType;

  get message => _message;

  get sender => _sender;


  factory Message.fromDTO(MessageDTO dto) {
    return Message(dto.message, dto.timestamp, dto.sender, dto.messageTyp, dto.status);
  }

  factory Message.fromJson(dynamic json) {
    return Message(
      json["message"],
      json["timestamp"],
      json["sender"],
      "receiver",
      "received"
    );
  }

  String getMessage() {
    return this._message;
  }

  String getTimestamp() {
    return this._timestamp;
  }

  @override
  String toString() {
    return '{"message": "$_message","timestamp": "$_timestamp", "sender": "$_sender", "messageType": "$_messageType"}';
  }
}