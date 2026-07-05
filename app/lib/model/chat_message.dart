import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_mappable/dart_mappable.dart';

part 'chat_message.mapper.dart';

@MappableClass()
class ChatMessage with ChatMessageMappable {
  final String id;
  final String message;
  final bool isFromMe;
  final DateTime timestamp;
  final String senderAlias;

  /// Group chat ID (null for 1:1 chat).
  final String? groupId;

  /// Attachment file name.
  final String? fileName;

  /// Local file path after download.
  final String? filePath;

  /// Attachment file size.
  final int? fileSize;

  /// Attachment MIME type.
  final String? fileType;

  /// Base64-encoded file data (thumbnail for images).
  final String? fileData;

  /// Whether the file has been downloaded locally.
  final bool fileDownloaded;

  const ChatMessage({
    required this.id,
    required this.message,
    required this.isFromMe,
    required this.timestamp,
    required this.senderAlias,
    this.groupId,
    this.fileName,
    this.filePath,
    this.fileSize,
    this.fileType,
    this.fileData,
    this.fileDownloaded = false,
  });

  bool get hasFile => fileName != null;
  bool get isImage => fileType != null && (fileType == 'jpg' || fileType == 'jpeg' || fileType == 'png' || fileType == 'gif' || fileType == 'webp' || fileType == 'bmp');
  bool get isVideo => fileType != null && (fileType == 'mp4' || fileType == 'mov' || fileType == 'avi' || fileType == 'mkv' || fileType == 'webm');

  Uint8List? get fileBytes => fileData != null ? base64Decode(fileData!) : null;

  static const fromJson = ChatMessageMapper.fromJson;
}
