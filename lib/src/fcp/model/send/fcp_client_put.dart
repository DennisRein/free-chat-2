import 'package:free_chat/src/fcp/fcp.dart';

class FcpClientPut extends FcpMessage {
  FcpClientPut(String uri, String data,
      {
      String metaDataContentType,
      String identifier,
      int verbosity,
      int maxRetries,
      int priorityClass,
      bool getCHKOnly,
      bool global,
      bool dontCompress,
      String clientToken,
      Persistence persistence,
      String targetFilename,
      bool earlyEncode,
      ReturnType uploadFrom,
      int dataLength,
      String filename,
      String targetUri,
      bool realTimeFlag,
      int extraInsertsSingleBlock,
      int extraInsertsSplitfileHeaderBlock,
      }) : super("ClientPut") {
    super.setField("URI", uri);
    super.setField("Metadata.ContentType", metaDataContentType);
    super.setField("Identifier", identifier);
    super.setField("Verbosity", verbosity);
    super.setField("MaxRetries", maxRetries);
    super.setField("PriorityClass", priorityClass);
    super.setField("GetCHKOnly", getCHKOnly ?? false);
    super.setField("Global", global ?? false);
    super.setField("DontCompress", dontCompress ?? false);
    super.setField("ClientToken", clientToken);
    super.setField("Persistence", persistence?.toShortString() ?? Persistence.connection.toShortString());
    super.setField("TargetFilename", targetFilename);
    super.setField("EarlyEncode", earlyEncode ?? false);
    super.setField("UploadFrom", uploadFrom?.toShortString() ?? ReturnType.direct.toShortString());
    super.setField("DataLength", dataLength);
    super.setField("Filename", filename);
    super.setField("TargetURI", targetUri);
    super.setField("RealTimeFlag", realTimeFlag ?? false);
    super.setField("ExtraInsertsSingleBlock", extraInsertsSingleBlock);
    super.setField("ExtraInsertsSplitfileHeaderBlock", extraInsertsSplitfileHeaderBlock);
    super.data = data;

  }
}