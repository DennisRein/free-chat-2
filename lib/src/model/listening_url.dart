class ListeningUrl {
  String _url;
  String _key;
  Function callback;

  ListeningUrl(this._url, this._key, this.callback);

  String getUrl() {
    return this._url;
  }

  String getKey() {
    return this._key;
  }


}