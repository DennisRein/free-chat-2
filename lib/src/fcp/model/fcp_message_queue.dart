import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:free_chat/src/fcp/model/fcp_model.dart';

class FcpMessageQueue extends ChangeNotifier {
  List<FcpMessage> _messageQueue = [];

  get messageQueue => _messageQueue;

  void addItemToQueue(FcpMessage message) {
    _messageQueue.add(message);
    notifyListeners();
  }

  FcpMessage getLastMessage() {
    if(_messageQueue.isEmpty) {
      return null;
    }
    return _messageQueue.last;
  }

  void removeItemFromQueue(int index) {
    _messageQueue.remove(index);
  }



}