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

  HashMap<String, Map<String, dynamic>> progress = HashMap();

  HashMap<String, String> identifierToUri = HashMap();

  handleMessage(FcpConnection _fcpConnection) {
    var msg = _fcpConnection.fcpMessageQueue.getLastMessage();
    _logger.i(msg.name);
    switch (msg.name) {
      case 'PersistentGet':
        {
          var ident = msg.getField("Identifier");
          break;
        }
      case 'PersistentPut':
        {
          var ident = msg.getField("Identifier");
          break;
        }
      case 'PutSuccessful':
        {
          Fluttertoast.showToast(
              msg: "Upload of one message finished!",
              toastLength: Toast.LENGTH_LONG);
          _identifiers.add(msg.getField('Identifier'));
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
            FcpClientGet clientGet = FcpClientGet(msg.getField("RedirectURI").replaceAll("Re-", ""), identifier: msg.getField("Identifier"), global: true, persistence: Persistence.forever);
            _fcpConnection.sendFcpMessage(clientGet);
          }
          if(msg.getField("Code") == "28") {

          }
          _logger.e(msg.toString());
          break;
        }
      case 'AllData':
        {
          if (msg.getField("Identifier").contains("-chat")) {
            Fluttertoast.showToast(
                msg: "New message has arrived!",
                toastLength: Toast.LENGTH_LONG);
            _logger.i("NEW MESSAGE => ${msg.toString()}");
            print(msg.getField("Identifier"));
            print(identifierToUri.toString());
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
          notifyListeners();
          break;
        }
      case 'SubscribedUSKUpdate':
        {
          var identifier = Uuid().v4() + "-chat";
          _logger.i("SubscribedUpdate $identifier + ${msg.getField("URI")}");

          FcpClientGet fcpClienteGet = FcpClientGet(msg.getField("URI"),
              identifier: identifier);

          identifierToUri[identifier] = msg.getField("URI");

          _fcpConnection.sendFcpMessage(fcpClienteGet);
        }
    }
  }
}
//68353420-2d87-4580-9d22-0f9b539e8778-chat + USK@hB8BSerNWPsaWM8TtektVejwCLs8FfImPtv1ivTkKUs,PWruJ0asNDCha2jSehxDXl58QziO9e05HkMlp3GFETo,AQACAAE/chat/4