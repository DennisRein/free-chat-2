import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:free_chat/src/fcp/fcp.dart';
import 'package:free_chat/src/model.dart';
import 'package:free_chat/src/network/database_handler.dart';
import 'package:free_chat/src/network/invite.dart';
import 'package:free_chat/src/network/networking.dart';
import 'package:free_chat/src/utils/logger.dart';
import 'package:free_chat/src/view.dart';

class HomeInviteController {

  static final HomeInviteController _homeInviteController = HomeInviteController._internal();

  final Logger _logger = Logger("HomeInviteController");

  factory HomeInviteController() {
    return _homeInviteController;
  }

  DatabaseHandler _databaseHandler = DatabaseHandler();

  Networking _networking = Networking();

  Invite _invite = Invite();

  HomeInviteController._internal();

  Future<void> inviteAccepted(InitialInvite invite, BuildContext context) async {

    LoadingPopup.build(context, "Joining Chatroom this can take up to a couple minutes");

    if(await _invite.inviteAccepted(invite)) {
      Navigator.pop(context);
      Navigator.pop(context);
    }
    else {
      Navigator.pop(context);
      Navigator.pop(context);
      ErrorPopup.build(context, "An error occured while trying to join the chat room, please try again later");
    }

  }

  void copyToClipboard(InitialInvite invite) {
    Clipboard.setData(new ClipboardData(text: invite.toBase64()));
    Fluttertoast.showToast(msg: "Copied to clipboard", toastLength: Toast.LENGTH_LONG);
  }

}