import 'package:free_chat/src/fcp/fcp.dart';

class FcpGetRequestStatus extends FcpMessage {
  FcpGetRequestStatus(String identifier, {bool global, bool onlyData}) : super("GetRequestStatus") {
    super.setField('Identifier', identifier);
    super.setField("Global", global ?? false);
    super.setField("OnlyData", onlyData ?? false);
  }
}