import 'package:free_chat/src/model.dart';

class ChatClient {
  SSKKey _key;
  String _name;


  ChatClient(this._key, this._name);

  SSKKey getKey() {
    return this._key;
  }

  String getName() {
    return this._name;
  }
}