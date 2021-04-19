import 'package:free_chat/src/fcp/model/fcp_message.dart';

class FcpGetNode extends FcpMessage {
  FcpGetNode({bool withPrivate, bool WithVolatile}) : super('GetNode') {
    super.setField("WithPrivate", withPrivate?.toString() ?? false.toString());
    super.setField("WithVolatile", WithVolatile?.toString() ?? false.toString());
  }
}