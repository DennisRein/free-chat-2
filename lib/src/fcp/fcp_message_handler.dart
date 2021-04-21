import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:free_chat/src/model.dart';
import 'package:free_chat/src/network/messaging.dart';
import 'package:free_chat/src/utils/logger.dart';

import 'fcp.dart';

class FcpMessageHandler extends ChangeNotifier {
  static final FcpMessageHandler _fcpMessageHandler =
      FcpMessageHandler._internal();

  factory FcpMessageHandler() {
    return _fcpMessageHandler;
  }

  FcpMessageHandler._internal();

  Logger _logger = Logger("FcpMessageHandler");

  Messaging _messaging = Messaging();

  List<String> _identifiers = [];

  List<String> _allData = [];

  HashMap<String, Map<String, dynamic>> progress = HashMap();

  HashMap<String, String> identifierToUri = HashMap();

  handleMessage(FcpConnection _fcpConnection) {
    var msg = _fcpConnection.fcpMessageQueue.getLastMessage();
    _logger.i(msg.name);
    switch (msg.name) {
      case 'PersistentGet':
        {
          break;
        }
      case 'PersistentPut':
        {
          break;
        }
      case 'PutSuccessful':
        {
          Fluttertoast.showToast(
              msg: "Upload of one message finished!",
              toastLength: Toast.LENGTH_LONG);
          _identifiers.add(msg.getField('Identifier'));
          _logger.i(msg.toString());
          break;
        }
      case 'PutFailed':
        {

          _logger.e(msg.toString());
          break;
        }
      case 'GetFailed':
        {
          _logger.i(msg.getField("Code"));
          if(msg.getField("Code") == "27") {
            _logger.i("Redirecting to new url");
            FcpClientGet clientGet = FcpClientGet(msg.getField("RedirectURI"), identifier: msg.getField("Identifier"), global: true, persistence: Persistence.forever, realTimeFlag: true);
            _fcpConnection.sendFcpMessage(clientGet);
          }
          if(msg.getField("Code") == "28") {
            Future.delayed(const Duration(seconds: 10), () => _fcpConnection.sendFcpMessage(FcpClientGet(identifierToUri[msg.getField("Identifier")],identifier: msg.getField("Identifier"), global: true, persistence: Persistence.forever, realTimeFlag: true)));
          }
          _logger.e(msg.toString() + identifierToUri[msg.getField("Identifier")]);
          break;
        }
      case 'AllData':
        {
          if(_allData.contains(msg.data))
            return;
          _allData.add(msg.data);
          if (msg.getField("Identifier").contains("-chat")) {
            Fluttertoast.showToast(
                msg: "New message has arrived!",
                toastLength: Toast.LENGTH_LONG);
            _messaging.updateChat(
                msg, identifierToUri[msg.getField("Identifier")]);
          }
          _identifiers.add(msg.getField('Identifier'));
          break;
        }
      case 'DataFound':
        {
          var ident = msg.getField('Identifier');

          if (_identifiers.contains(ident)) break;
          _fcpConnection
              .sendFcpMessage(FcpGetRequestStatus(ident, global: true));
          _identifiers.add(ident);
          break;
        }
      case 'ProtocolError':
        {
          _logger.e(msg.toString());
          break;
        }
      case 'SimpleProgress':
        {
          var ident = msg.getField('Identifier');
          progress[ident] = {
            "Total": msg.getField("Total"),
            "Succeeded": msg.getField("Succeeded")
          };
          if(_allData.contains(ident) || _identifiers.contains(ident)) {
            break;
          }
          Future.delayed(const Duration(seconds: 10), () => _fcpConnection.sendFcpMessage(FcpGetRequestStatus(ident, global: true)));
          notifyListeners();
          break;
        }
      case 'SubscribedUSKUpdate':
        {
          var identifier = Uuid().v4() + "-chat";
          _logger.i("SubscribedUpdate $identifier + ${msg.getField("URI")}");

          FcpClientGet fcpClienteGet = FcpClientGet(msg.getField("URI"),
              identifier: identifier, maxRetries: -1, realTimeFlag: true);

          identifierToUri[identifier] = msg.getField("URI");

          Future.delayed(Duration(seconds: 10), () => _fcpConnection.sendFcpMessage(fcpClienteGet));
        }
    }
  }
}