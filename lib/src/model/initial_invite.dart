class InitialInvite {
  String _handshakeUri;
  String _publicKey;
  String _requestUri;
  String _name;
  String _encryptKey;
  String _insertUri;

  InitialInvite(this._requestUri, this._handshakeUri, this._name, this._encryptKey, this._insertUri);

  get insertUri => _insertUri;

  factory InitialInvite.fromJson(dynamic json) {
    return InitialInvite(json["requestUri"], json["handshakeUri"], json["name"], json["encryptKey"], "");
  }

  @override
  String toString() {
    return """
      {"requestUri": "$_requestUri", "handshakeUri": "$_handshakeUri", "name": "$_name", "encryptKey": "$_encryptKey"}
    """;
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