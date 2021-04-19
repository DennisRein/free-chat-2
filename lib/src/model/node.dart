import 'package:flutter/material.dart';

class Node {
  String _node;
  String _fcpVersion;
  String _build;
  String _version;
  bool _connected;

  Node(this._node, this._fcpVersion, this._build, this._version,
      this._connected);

  factory Node.fromJson(dynamic json) {
    return Node(
      json["Node"],
      json["FCPVersion"],
      json["Build"],
      json["Build"],
      true
    );
  }

  String getNodeName() {
    return _node;
  }

  String getFcpVersion() {
    return _fcpVersion;
  }

  String getBuild() {
    return _build;
  }

  String getVersion() {
    return _version;
  }

  bool isConnected() {
    return _connected;
  }


}