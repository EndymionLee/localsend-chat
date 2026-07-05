import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:common/api_route_builder.dart';
import 'package:common/model/dto/chat_message_dto.dart';
import 'package:common/model/stored_security_context.dart';
import 'package:localsend_app/util/rhttp.dart';
import 'package:logging/logging.dart';
import 'package:rhttp/rhttp.dart';

final _logger = Logger('ChatHttpClient');

class ChatHttpClient {
  final StoredSecurityContext _securityContext;

  ChatHttpClient(this._securityContext);

  Future<bool> sendChatMessage({
    required String targetIp,
    required int targetPort,
    required bool targetHttps,
    required String message,
    required String senderAlias,
    required String senderFingerprint,
    String? groupId,
    String? fileName,
    int? fileSize,
    String? fileType,
    Uint8List? fileBytes,
  }) async {
    final dto = ChatMessageDto(
      message: message,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      senderAlias: senderAlias,
      senderFingerprint: senderFingerprint,
      groupId: groupId,
      fileName: fileName,
      fileSize: fileSize,
      fileType: fileType,
      fileData: fileBytes != null ? base64Encode(fileBytes) : null,
    );

    final url = ApiRoute.chat.targetRaw(targetIp, targetPort, targetHttps, '2.0');

    try {
      final client = createRhttpClient(const Duration(seconds: 10), _securityContext);
      try {
        await client.post(url, body: HttpBody.json(dto.toJson()));
        return true;
      } on RhttpStatusCodeException catch (e) {
        _logger.warning('Chat send failed to $targetIp:$targetPort (status ${e.statusCode})');
        return false;
      }
    } catch (e) {
      _logger.warning('Chat send failed to $targetIp:$targetPort: $e');
      return false;
    }
  }

  /// Sends a message to multiple recipients (for group chat).
  Future<void> sendGroupMessage({
    required List<({String ip, int port, bool https})> targets,
    required String message,
    required String senderAlias,
    required String senderFingerprint,
    required String groupId,
    String? fileName,
    int? fileSize,
    String? fileType,
    Uint8List? fileBytes,
  }) async {
    for (final target in targets) {
      // Don't send to self
      unawaited(
        sendChatMessage(
          targetIp: target.ip,
          targetPort: target.port,
          targetHttps: target.https,
          message: message,
          senderAlias: senderAlias,
          senderFingerprint: senderFingerprint,
          groupId: groupId,
          fileName: fileName,
          fileSize: fileSize,
          fileType: fileType,
          fileBytes: fileBytes,
        ),
      );
    }
  }
}
