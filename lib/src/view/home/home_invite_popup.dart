import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:free_chat/src/controller/home_invite_controller.dart';
import 'package:free_chat/src/model.dart';
import 'package:qr_flutter/qr_flutter.dart';
class HomeInvitePopup {

  HomeInviteController _homeInviteController = HomeInviteController();

  Widget buildPopupDialog(BuildContext context, InitialInvite invite) {
    return new AlertDialog(
      title: Text('Invite a FreeChat user to chat with you'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Container(
                height: 300,
                width: 300,
                child:
                QrImage(
                  data: invite.toString(),
                  version: QrVersions.auto,
                  size: 300,
                )
            )
          ],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
        ElevatedButton(onPressed: () async => { await _homeInviteController.inviteAccepted(invite, context) }, child: Text("Done"), style: ElevatedButton.styleFrom(

        )
        ),
      ],
    );
  }

  static build(BuildContext context, InitialInvite invite) {
    showDialog(
      context: context,
      builder: (BuildContext context) => HomeInvitePopup().buildPopupDialog(context, invite),
    );
  }
}
