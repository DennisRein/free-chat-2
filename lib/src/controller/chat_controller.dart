import 'package:date_format/date_format.dart';
import 'package:free_chat/src/config.dart';
import 'package:free_chat/src/network/messaging.dart';
import 'package:free_chat/src/utils/logger.dart';

import '../model.dart';

class ChatController {
  static final ChatController _chatController = ChatController._internal();

  final Logger _logger = Logger("ChatController");

  final Messaging _messaging = Messaging();

  factory ChatController() {
    return _chatController;
  }

  ChatController._internal();

  Future<void> sendMessage(ChatDTO chat, String text) async {

    var timestamp = formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn]);

    Message message = Message(text, timestamp, Config.clientName, "sender", "sending");

    await _messaging.sendMessage(chat, message);
  }
}