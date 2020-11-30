import '../message/base_message.dart';
import '../message/file_message.dart';

typedef void OnUploadProgressCallback(int sentBytes, int totalBytes);
typedef void OnMessageCallback(BaseMessage message, Error error);
typedef void OnFileMessageCallback(FileMessage message, Error error);
typedef void OnUserMessageCallback(FileMessage message, Error error);