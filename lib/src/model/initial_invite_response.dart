import 'dart:convert';

import 'package:free_chat/src/utils/converter.dart';

class InitialInviteResponse {
  String _requestUri;
  String _name;

  InitialInviteResponse(this._requestUri, this._name);

  get requestUri => _requestUri;
  get name => _name;

  factory InitialInviteResponse.fromJson(dynamic json) {
    return InitialInviteResponse(json["requestUri"], json["name"]);
  }

  @override
  String toString() {
    return '{"requestUri": "$_requestUri", "name": "$_name"}';
  }

  String toBase64() {
    return Converter.stringToBase64.encode(toString());
  }
  factory InitialInviteResponse.fromBase64(String base64) {
    return InitialInviteResponse.fromJson(jsonDecode(Converter.stringToBase64.decode(base64)));
  }

}