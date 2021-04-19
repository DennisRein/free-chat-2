class FcpMessage {
  String _name;

  Map<String, dynamic> _fields = Map();

  String data = "";

  FcpMessage(this._name);

  get name => this._name;

  FcpMessage.fromString(String content) {
    var contents = content.split("\n");
    this._name = contents.first;

    for(var con in contents) {
      if(con == "EndMessage") break;
      else if(con == "Data") {
        data = content.split("Data")[1];
        break;
      }
      var keyVal = con.split("=");
      this.setField(keyVal.first, keyVal.last);
    }

  }

  void setField(String key, dynamic value) {
    if(value == null) return;
    _fields[key] = value;
  }

  dynamic getField(String field) {
    return _fields[field];
  }

  @override toString() {
    String message =
        "$_name\n";
    _fields.forEach((key, value) {
      message = message + "$key=$value\n";
    });
    message +=  data.isEmpty ? "EndMessage\n" : "Data\n$data";

    return message;
  }

  Map<String, dynamic> toJson() => {
    'name': _name,
    for(var key in _fields.keys)
      key: _fields[key]
  };

}