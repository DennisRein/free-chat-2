class SSKKey {
  String _insertUri;
  String _requestUri;

  SSKKey(this._insertUri, this._requestUri);

  factory SSKKey.fromJson(dynamic json) {
    return SSKKey(json["InsertURI"], json["RequestURI"]);
  }

  String getInsertUri(){
    return _insertUri;
  }

  String getAsUskInsertUri() {
    return "USK@${_insertUri.split("@")[1]}";
  }


  String getAsUskRequestUri() {
    return "USK@${_requestUri.split("@")[1]}";
  }

  String getRequestUri() {
    return _requestUri;
  }

}