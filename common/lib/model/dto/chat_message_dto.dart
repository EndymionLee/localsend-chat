import 'package:dart_mappable/dart_mappable.dart';

part 'chat_message_dto.mapper.dart';

@MappableClass()
class ChatMessageDto with ChatMessageDtoMappable {
  /// Text message content.
  final String message;

  /// Millisecond timestamp.
  final int timestamp;

  /// Sender's device alias.
  final String senderAlias;

  /// Sender's device fingerprint (used to identify the conversation).
  final String senderFingerprint;

  /// Optional group ID (if this is a group message).
  final String? groupId;

  /// Optional file attachment name.
  final String? fileName;

  /// Optional file attachment size in bytes.
  final int? fileSize;

  /// Optional file MIME type.
  final String? fileType;

  /// Optional base64-encoded file bytes (for small files / image thumbnails).
  final String? fileData;

  const ChatMessageDto({
    required this.message,
    required this.timestamp,
    required this.senderAlias,
    required this.senderFingerprint,
    this.groupId,
    this.fileName,
    this.fileSize,
    this.fileType,
    this.fileData,
  });

  static const fromJson = ChatMessageDtoMapper.fromJson;
}
