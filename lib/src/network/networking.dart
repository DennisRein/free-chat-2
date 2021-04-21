import 'dart:async';
import 'dart:convert';

import 'package:free_chat/src/fcp/fcp.dart';
import 'package:free_chat/src/fcp/model/persistence.dart';
import 'package:free_chat/src/model.dart';
import 'package:free_chat/src/utils/device.dart';
import 'package:free_chat/src/utils/logger.dart';

class Networking {

  bool _connected = false;

  static final Networking _networking = Networking._internal();

  static final Logger _logger = Logger(Networking().toString());

  final Codec<String, String> stringToBase64 = utf8.fuse(base64);

  FcpConnection fcpConnection;

  factory Networking() {
    return _networking;
  }

  Networking._internal();

  Future<Node> connectClient() async {

    var _deviceId = Uuid().v4();
    fcpConnection = FcpConnection();

    await fcpConnection.connect();

    fcpConnection.fcpMessageQueue.addListener(() => FcpMessageHandler().handleMessage(fcpConnection));

    FcpClientHello clientHello = FcpClientHello(_deviceId);
    var json = await fcpConnection.sendFcpMessageAndWait(clientHello);

    FcpWatchGlobal fcpWatchGlobal = FcpWatchGlobal(enabled: true);

    await fcpConnection.sendFcpMessage(fcpWatchGlobal);

    return Node.fromJson(json.toJson());
  }

  bool isConnected() {
    return _connected;
  }

  Future<SSKKey> getKeys() async {
    FcpGenerateSSK fcpGenerateSSK = FcpGenerateSSK(identifier: Uuid().v4());

    FcpMessage response = await fcpConnection.sendFcpMessageAndWaitWithAwaitedResponse(fcpGenerateSSK, "SSKKeypair");

    return SSKKey.fromJson(response.toJson());
  }

  Future<FcpMessage> getMessage(String uri, String identifier) async {
    FcpClientGet fcpClienteGet = FcpClientGet(uri, identifier: identifier, global: true, persistence: Persistence.forever, realTimeFlag: true);

    FcpMessage t = await fcpConnection.sendFcpMessageAndWaitWithAwaitedResponse(fcpClienteGet, "AllData");

    var data = t.data;
    stringToBase64.decode(data);

    t.data = stringToBase64.decode(data);

    return t;
  }

  Future<FcpMessage> sendMessage(String uri, String data, String identifier) async {
    var base64Str = stringToBase64.encode(data) + "\n";

    FcpClientPut put = FcpClientPut(uri, base64Str, priorityClass: 2, dontCompress: true, identifier: identifier, global: true, persistence: Persistence.forever, dataLength: base64Str.length, metaDataContentType: "", realTimeFlag: true, extraInsertsSingleBlock: 0, extraInsertsSplitfileHeaderBlock: 0);

    _logger.i("Sending message: ${put.toString()}");

    FcpMessage t = await fcpConnection.sendFcpMessageAndWaitWithAwaitedResponse(put, "PutSuccessful", errorResponse: "PutFailed");

    if(t.name == "PutFailed") {
      throw Exception(t);
    }

    _logger.i("Put Status: $t}");

    return t;
  }

  Future<void> update(ChatDTO chatDTO) async {
    FcpClientGet fcpClienteGet = FcpClientGet(chatDTO.requestUri, identifier: Uuid().v4() + "-chat", realTimeFlag: true, global: true, persistence: Persistence.forever);
    FcpSubscribeUSK fcpSubscribeUSK = FcpSubscribeUSK(chatDTO.requestUri, Uuid().v4());

    fcpConnection.sendFcpMessage(fcpClienteGet);
    fcpConnection.sendFcpMessage(fcpSubscribeUSK);
  }



}