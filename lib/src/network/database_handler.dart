import 'dart:io';

import 'package:free_chat/src/model.dart';
import 'package:free_chat/src/model/chat_dto.dart';
import 'package:free_chat/src/utils/logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHandler {
  static final Logger _logger = Logger("DatabaseHandler");

  Database _database;

  static final DatabaseHandler _databaseHandler = DatabaseHandler._internal();


  factory DatabaseHandler() {
    return _databaseHandler;
  }

  DatabaseHandler._internal();

  Future<void> initializeDatabase(String databaseName) async {

    String createChat = "CREATE TABLE chat(id INTEGER PRIMARY KEY, insertUri TEXT, requestUri TEXT, encryptKey TEXT, name TEXT, sharedId TEXT)";
    String createMessage = "CREATE TABLE message(id INTEGER PRIMARY KEY, sender TEXT, message TEXT, status TEXT, timestamp TEXT, chatId INTEGER, messageType TEXT, FOREIGN KEY (chatId) REFERENCES Chat (id) ON DELETE NO ACTION ON UPDATE NO ACTION)";

    if(Platform.isAndroid || Platform.isIOS) {
      _database = await openDatabase(
        join(await getDatabasesPath(), '$databaseName.db'),
        onCreate: (db, version) {
          return Future.wait([
            db.execute(
              "CREATE TABLE chat(id INTEGER PRIMARY KEY, insertUri TEXT, requestUri TEXT, encryptKey TEXT, name TEXT, sharedId TEXT)",
            ),
            db.execute(
              "CREATE TABLE message(id INTEGER PRIMARY KEY, sender TEXT, message TEXT, status TEXT, timestamp TEXT, chatId INTEGER, messageType TEXT, FOREIGN KEY (chatId) REFERENCES Chat (id) ON DELETE NO ACTION ON UPDATE NO ACTION)",
            )
          ]);
        },
        version: 1,
      );
    }
    else {
      sqfliteFfiInit();

      var databaseFactory = databaseFactoryFfi;

      _database = await databaseFactory.openDatabase(inMemoryDatabasePath);

      await _database.execute("CREATE TABLE chat(id INTEGER PRIMARY KEY, insertUri TEXT, requestUri TEXT, encryptKey TEXT, name TEXT, sharedId TEXT)");
      await _database.execute("CREATE TABLE message(id INTEGER PRIMARY KEY, sender TEXT, message TEXT, status TEXT, timestamp TEXT, chatId INTEGER, messageType TEXT, FOREIGN KEY (chatId) REFERENCES Chat (id) ON DELETE NO ACTION ON UPDATE NO ACTION)");
    }
  }

  Future<ChatDTO> upsertChat(ChatDTO chat) async {

    var count = Sqflite.firstIntValue(await _database.rawQuery(
        "SELECT COUNT(*) FROM chat WHERE insertUri = ?", [chat.insertUri]));
    if (count == 0) {
      chat.id = await _database.insert("chat", chat.toMap());
    } else {
      await _database.update("chat", chat.toMap(), where: "insertUri = ?",
          whereArgs: [chat.insertUri]);
    }

    return chat;
  }

  Future<MessageDTO> upsertMessage(MessageDTO message) async {
    if (message.id == null) {
      message.id = await _database.insert("message", message.toMap());
    } else {
      await _database.update(
          "message", message.toMap(), where: "id = ?", whereArgs: [message.id]);
    }

    return message;
  }

  Future<ChatDTO> fetchChat(int id) async {
    List<Map> results = await _database.query(
        "chat", columns: ChatDTO.columns, where: "id = ?", whereArgs: [id]);

    ChatDTO chat = ChatDTO.fromMap(results[0]);

    return chat;
  }

  Future<ChatDTO> fetchChatByInsertUri(String insertUri) async {
    List<Map> results = await _database.query("chat", columns: ChatDTO.columns,
        where: "insertUri = ?",
        whereArgs: [insertUri]);

    if (results.length == 0)
      return null;

    ChatDTO chat = ChatDTO.fromMap(results[0]);

    return chat;
  }

  Future<ChatDTO> fetchChatBySharedId(String sharedId) async {
    List<Map> results = await _database.query("chat", columns: ChatDTO.columns,
        where: "sharedId = ?",
        whereArgs: [sharedId]);

    if (results.length == 0)
      return null;

    ChatDTO chat = ChatDTO.fromMap(results[0]);

    return chat;
  }

  Future<ChatDTO> fetchChatByRequestUri(String requestUri) async {
    List<Map> results = await _database.query("chat", columns: ChatDTO.columns,
        where: "requestUri LIKE ?",
        whereArgs: [
          "${requestUri.split("/")[0]}%"
        ]);

    if (results.length == 0)
      return null;

    ChatDTO chat = ChatDTO.fromMap(results[0]);

    return chat;
  }

  Future<MessageDTO> fetchMessage(int id) async {
    List<Map> results = await _database.query(
        "message", columns: MessageDTO.columns,
        where: "id = ?",
        whereArgs: [id]);

    MessageDTO message = MessageDTO.fromMap(results[0]);

    return message;
  }

  Future<Chat> fetchChatAndMessages(int id) async {
    List<Map> results = await _database.query(
        "chat", columns: ChatDTO.columns, where: "id = ?", whereArgs: [id]);

    ChatDTO chatDTO = ChatDTO.fromMap(results[0]);

    Chat chat = Chat.fromDTO(chatDTO, []);

    List<Map> results2 = await _database.rawQuery(
        "SELECT * FROM message WHERE chatId = ? ORDER BY timestamp ASC", [id]);

    List<Message> message = [];

    for (var res in results2) {
      MessageDTO messageDTO = MessageDTO.fromMap(res);
      Message message = Message.fromDTO(messageDTO);
      chat.addMessage(message);
    }

    return chat;
  }

  Future<List<ChatDTO>> fetchAllChats() async {
    List<Map> results2 = await _database.rawQuery("SELECT * FROM chat");

    List<ChatDTO> chats = [];

    for (var res in results2) {
      ChatDTO chat = ChatDTO.fromMap(res);
      chats.add(chat);
    }

    return chats;
  }
}