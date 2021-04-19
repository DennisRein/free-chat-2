import 'package:free_chat/src/fcp/fcp.dart';

class FcpWatchGlobal extends FcpMessage{
  FcpWatchGlobal({bool enabled, int verbosityMask}) : super("WatchGlobal") {
    super.setField("Enabled", enabled);
    super.setField("VerbosityMask", verbosityMask);
  }
}