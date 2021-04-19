import 'package:free_chat/src/fcp/model/fcp_message.dart';

class FcpClientHello extends FcpMessage {
  FcpClientHello(String name, {String version}) : super("ClientHello") {
    super.setField("Name", name);
    super.setField("ExpectedVersion", version ?? "2.0");
  }
}