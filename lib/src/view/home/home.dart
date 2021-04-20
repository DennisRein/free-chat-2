import 'package:flutter/scheduler.dart';
import 'package:free_chat/src/config.dart';
import 'package:free_chat/src/controller.dart';
import 'package:flutter/material.dart';
import 'package:free_chat/src/network/database_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../view.dart';

class Home extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<Home> {

  HomeController homeController = HomeController();
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    DatabaseHandler _databaseHandler = DatabaseHandler();

    await _databaseHandler.initializeDatabase("free-chat");

    await homeController.initNode();

    if(sharedPreferences.containsKey("clientName")) {
      Config.clientName = sharedPreferences.getString("clientName");
    }
    else {
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        Config.clientName = await HomeNamePopup.build(context, sharedPreferences);
      });
    }




    if (!mounted) return;

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
            appBar: AppBar(
              title: const Text('FreeChat'),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => Chats()),),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: SingleChildScrollView(
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(homeController.getTextForButton()),
                        SizedBox(height: 35.0),
                        ElevatedButton(onPressed: () async { await homeController.invite(context); setState(() { }); }, child: Text("Invite to Chat"), style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(
                              fontSize: 40,
                            fontFamily: "PTSans"
                          ),
                        )
                        ),
                        SizedBox(
                          height: 35.0,
                        ),
                        ElevatedButton(onPressed: () => setState(() { homeController.join(context); }), child: Text("Join Chat"), style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(
                            fontSize: 40,
                              fontFamily: "PTSans"
                          ),
                        )
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
