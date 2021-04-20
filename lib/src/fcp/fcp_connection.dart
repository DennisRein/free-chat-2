import 'dart:async';
import 'dart:io';

import 'package:free_chat/src/fcp/fcp.dart';
import 'package:free_chat/src/utils/logger.dart';
import 'package:web_socket_channel/io.dart';

import 'model/fcp_message.dart';

class FcpConnection {

  int _port;

  String _host;

  InternetAddress _address;

  Socket socket;

  String response;

  final int defaultPort = 9481;

  final Logger _logger = Logger("FcpConnection");

  final FcpMessageQueue fcpMessageQueue = FcpMessageQueue();

  FcpMessage _foundMessage;

  FcpConnection() {
    this._port = defaultPort;
    this._host = "localhost";
  }

  FcpConnection.withPort(int port) {
    this._port = port;
    this._host = "wss://localhost";
  }

  FcpConnection.withHostAndPort(String host, int port) {
    this._port = port;
    this._host = host;
  }

  Future<void> connect() async {
    _logger.i("Connecting to $_host on Port $_port");
    socket = await Socket.connect(_host, _port).then((Socket sock) {
      socket = sock;
      socket.listen(dataHandler,
          onError: errorHandler,
          onDone: doneHandler,
          cancelOnError: false);
      return socket;
    });
  }

  void dataHandler(data) {

    FcpMessage fcpMessage = null;

    String msg = new String.fromCharCodes(data).trim();
    bool flag = false;
    for(var line in msg.split("\n")) {
      if (line == null) {
        fcpMessageQueue.addItemToQueue(fcpMessage);
        break;
      }
      if (flag) {

        fcpMessage.data = line;
        fcpMessageQueue.addItemToQueue(fcpMessage);
        fcpMessage = null;

        flag = false;
        continue;
      }
      if (line.length == 0) {
        continue;
      }
      line = line.trim();
      if (fcpMessage == null) {
        fcpMessage = new FcpMessage(line);
        continue;
      }
      if (line.toLowerCase() == "EndMessage".toLowerCase()) {
        //fcpConnection.handleMessage(fcpMessage);

        fcpMessageQueue.addItemToQueue(fcpMessage);
        fcpMessage = null;
      }
      if("Data".toLowerCase() == line.toLowerCase()) {
        flag = true;
      }
      int equalSign = line.indexOf('=');
      if (equalSign == -1) {
        continue;
      }
      String field = line.substring(0, equalSign);
      String value = line.substring(equalSign + 1);
      assert(fcpMessage != null);
      fcpMessage.setField(field, value);
    }
  }

  AsyncError errorHandler(Object error, StackTrace trace) {
    _logger.e(error);
    return null;
  }

  void doneHandler() {
    socket.destroy();
  }

  Future<void> sendFcpMessage(FcpMessage message) async {
    _logger.i("Sending message: ${message.toString()}");
    socket.write(message);
    FcpMessageHandler().identifierToUri[message.getField("Identifier")] = message.getField("URI");
  }

  Future<FcpMessage> sendFcpMessageAndWait(FcpMessage message) async {
    socket.write(message);
    FcpMessageHandler().identifierToUri[message.getField("Identifier")] = message.getField("URI");
    FcpMessage lastMessage = fcpMessageQueue.getLastMessage();

    await waitWhile(() => lastMessage == fcpMessageQueue.getLastMessage());

    return fcpMessageQueue.getLastMessage();
  }

  Future<FcpMessage> sendFcpMessageAndWaitWithAwaitedResponse(FcpMessage message, String awaitedResponse) async {
    socket.write(message);
    FcpMessageHandler().identifierToUri[message.getField("Identifier")] = message.getField("URI");

    await waitWhile(() => !(containsMessage(awaitedResponse, message.getField("Identifier"))));

    return _foundMessage;
  }

  bool containsMessage(String type, String identifier) {
    bool has = false;
    for(FcpMessage msg in fcpMessageQueue.messageQueue) {
      if(msg.name == type && msg.getField("Identifier") == identifier) {
        has = true;
        _foundMessage = msg;
      }
    }
    return has;
  }

  Future waitWhile(bool test(), [Duration pollInterval = Duration.zero]) {
    var completer = new Completer();
    check() {
      if (!test()) {
        completer.complete();
      } else {
        new Timer(pollInterval, check);
      }
    }
    check();
    return completer.future;
  }
}