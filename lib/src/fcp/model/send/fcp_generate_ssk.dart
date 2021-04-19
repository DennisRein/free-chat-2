import '../../fcp.dart';

class FcpGenerateSSK extends FcpMessage {
  FcpGenerateSSK({String identifier}) : super("GenerateSSK") {
    super.setField("Identifier", identifier);
  }
}