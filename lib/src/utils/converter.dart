import 'dart:convert';

class Converter {
  static dynamic toJson(String jsonString) {
    return jsonDecode(jsonString);
  }
}