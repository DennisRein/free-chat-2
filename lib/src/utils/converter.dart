import 'dart:convert';

class Converter {
  static dynamic toJson(String jsonString) {
    return jsonDecode(jsonString);
  }

  static final Codec<String, String> stringToBase64 = utf8.fuse(base64);
}