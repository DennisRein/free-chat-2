import 'dart:convert';

import 'package:free_chat/src/utils/converter.dart';

class InitialInvite {
  String _handshakeUri;
  String _publicKey;
  String _requestUri;
  String _name;
  String _encryptKey;
  String _insertUri;
  String _sharedId;

  InitialInvite(this._requestUri, this._handshakeUri, this._name, this._encryptKey, this._insertUri, this._sharedId);

  get insertUri => _insertUri;

  get sharedId => _sharedId;

  factory InitialInvite.fromJson(dynamic json) {
    return InitialInvite(json["requestUri"], json["handshakeUri"], json["name"], json["encryptKey"], "", json["sharedId"]);
  }

  String toBase64() {
    return Converter.stringToBase64.encode(toString());
  }

  factory InitialInvite.fromBase64(String base64) {
    return InitialInvite.fromJson(jsonDecode(Converter.stringToBase64.decode(base64)));
  }

  @override
  String toString() {
    return """
      {"sharedId": "$_sharedId", "requestUri": "$_requestUri", "handshakeUri": "$_handshakeUri", "name": "$_name", "encryptKey": "$_encryptKey"}
    """.trim();
  }

  String getRequestUri() {
    return _requestUri;
  }

  String getPublicKey() {
    return _publicKey;
  }

  String getHandshakeUri() {
    return _handshakeUri;
  }

  String getName() {
    return _name;
  }

  String getIdentifier() {
    return _requestUri.split("/")[1];
  }

  get encryptKey => _encryptKey;


}