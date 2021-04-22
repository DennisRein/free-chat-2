import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:free_chat/src/fcp/fcp.dart';


class LoadingPopupWithProgress extends StatefulWidget {

  String text;

  List<String> identifiersToListenTo;

  LoadingPopupWithProgress(this.text, this.identifiersToListenTo);

  @override
  State<StatefulWidget> createState() => _LoadingPopupWithProgressState();
}

class _LoadingPopupWithProgressState extends State<LoadingPopupWithProgress> {

  String messageText;

  @override
  void initState() {
    FcpMessageHandler().addListener(() {

      if(!mounted)
        return;

      String progress = "";
      int total = 0;
      int successful = 0;
      for(var prog in FcpMessageHandler().progress.keys) {
        if(!(widget.identifiersToListenTo.contains(prog) || widget.identifiersToListenTo.contains(prog + "-handshake-0") || widget.identifiersToListenTo.contains(prog + "-handshake-1") || widget.identifiersToListenTo.contains(prog + "-handshake-2")))
          continue;
        total = total + int.parse(FcpMessageHandler().progress[prog]["Total"]);
        successful = successful + int.parse(FcpMessageHandler().progress[prog]["Succeeded"]);
      }

      messageText = "${widget.text} ($successful/$total)";
      setState(() {

      });
    });



    messageText = widget.text;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: Text(messageText),
      content: SingleChildScrollView(
          child: Center(
            child:
            const SpinKitRing(color: Colors.blue),
          )
      ),
    );
  }

}

class LoadingPopupWithProgressCall {
  static void build(BuildContext context, String text, List<String> identifiersToListenTo) {
    showDialog(
      context: context,
      builder: (BuildContext context) => LoadingPopupWithProgress(text, identifiersToListenTo),
    );
  }
}