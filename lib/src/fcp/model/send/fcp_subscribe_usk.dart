import 'package:free_chat/src/fcp/fcp.dart';

class FcpSubscribeUSK extends FcpMessage {
  FcpSubscribeUSK(String uri, String identifier, {bool dontPool, int priorityClass,
    int priorityClassProgress, bool realTimeFlag, bool SparsePoll, bool ignoreUSKDatehints}) : super("SubscribeUSK") {

    super.setField('URI', uri);
    super.setField('Identifier', identifier);
    super.setField("DontPoll", dontPool ?? false);
    super.setField("PriorityClass", priorityClass);
    super.setField("PriorityClassProgress", priorityClassProgress);
    super.setField("SparsePoll", SparsePoll ?? false);
    super.setField("IgnoreUSKDatehints", ignoreUSKDatehints ?? false);
  }
}