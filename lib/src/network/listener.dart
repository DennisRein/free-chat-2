


import 'dart:async';

import 'package:free_chat/src/network/networking.dart';
import 'package:free_chat/src/utils/logger.dart';

import '../model.dart';

class Listener {

  static final Logger _logger = Logger(Listener().toString());

  static final Listener _listener = Listener._internal();

  final List<ListeningUrl> _listeningQueue = [];

  final Networking _networking = Networking();

  factory Listener() {
    return _listener;
  }

  Listener._internal();

  void addToQueue(ListeningUrl url) {
    _listeningQueue.add(url);
  }

  int getQueueLength() {
    return _listeningQueue.length;
  }
}