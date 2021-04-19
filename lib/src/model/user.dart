class User {
  String _username;
  String _publicKey;

  User(this._username, this._publicKey);

  factory User.fromJson(dynamic json) {
    return User(
      json["username"],
      json["publicKey"]
    );
  }

  String getUsername() {
    return this._username;
  }

  String getPublicKey() {
    return this._publicKey;
  }

  @override
  String toString() {
    return """
    {
      "username": "$_username",
      "publicKey": "$_publicKey"
    }""";
  }

}
