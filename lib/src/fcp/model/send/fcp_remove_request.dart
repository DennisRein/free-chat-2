import '../../fcp.dart';

class FcpRemoveRequest extends FcpMessage {
  FcpRemoveRequest(String identifier, {bool global}) : super("RemoveRequest") {
    super.setField("Identifier", identifier);
    super.setField("Global", global ?? false);
  }
}
