import 'package:free_chat/src/fcp/fcp.dart';

class FcpClientGet extends FcpMessage {
  FcpClientGet(String uri, {bool ignoreDs, bool dsOnly, String identifier,
                 int verbosity, int maxSize, int maxTempSize, int maxRetries,
                 int priorityClass, Persistence persistence, String clientToken,
                 bool global, ReturnType returnType, bool binaryBlob, bool filterData, bool realTimeFlag
                 }) : super('ClientGet') {
    super.setField("URI", uri);
    super.setField("IgnoreDS", ignoreDs ?? false);
    super.setField("DSonly", dsOnly ?? false);
    super.setField("Identifier", identifier);
    super.setField("Verbosity", verbosity);
    super.setField("MaxSize", maxSize);
    super.setField("MaxTempSize", maxTempSize);
    super.setField("MaxRetries", maxRetries);
    super.setField("PriorityClass", priorityClass);
    super.setField("Persistence", persistence?.toShortString() ?? Persistence.connection.toShortString());
    super.setField("ClientToken", clientToken);
    super.setField("Global", global ?? false);
    super.setField("ReturnType", returnType?.toShortString() ?? ReturnType.direct.toShortString());
    super.setField("BinaryBlob", binaryBlob ?? false);
    super.setField("FilterData", filterData ?? false);
    super.setField("RealTimeFlag", realTimeFlag ?? false);
  }
}