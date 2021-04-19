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

}