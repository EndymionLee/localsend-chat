import 'dart:convert';
import 'dart:io';

import 'package:common/api_route_builder.dart';
import 'package:common/model/dto/chat_message_dto.dart';
import 'package:flutter/services.dart';
import 'package:localsend_app/provider/chat_provider.dart';
import 'package:localsend_app/provider/network/server/server_utils.dart';
import 'package:localsend_app/provider/settings_provider.dart';
import 'package:localsend_app/util/simple_server.dart';
import 'package:logging/logging.dart';

final _logger = Logger('ChatController');

/// Magic prefix to identify clipboard share messages.
const _clipboardMarker = '__CLIPBOARD__';

class ChatController {
  final ServerUtils server;

  ChatController(this.server);

  void installRoutes({
    required SimpleServerRouteBuilder router,
    required String alias,
    required String fingerprint,
  }) {
    router.post(ApiRoute.chat.v2, (HttpRequest request) async {
      await _chatHandler(request: request, alias: alias, fingerprint: fingerprint);
    });
  }

  Future<void> _chatHandler({
    required HttpRequest request,
    required String alias,
    required String fingerprint,
  }) async {
    final ChatMessageDto dto;
    try {
      final payload = await request.readAsString();
      dto = ChatMessageDtoMapper.fromJson(jsonDecode(payload));
    } catch (e) {
      _logger.warning('Failed to parse chat message: $e');
      return await request.respondJson(400, message: 'Malformed request body');
    }

    if (dto.senderFingerprint == fingerprint) {
      return await request.respondJson(200);
    }

    // Handle clipboard sharing — only sync clipboard, never save as chat message.
    if (dto.fileName == _clipboardMarker) {
      final settings = server.ref.read(settingsProvider);
      if (settings.sharedClipboard) {
        await Clipboard.setData(ClipboardData(text: dto.message));
        _logger.info('Clipboard synced from ${dto.senderAlias}');
      }
      return await request.respondJson(200);
    }

    try {
      if (dto.groupId != null) {
        await server.ref.redux(chatGroupProvider).dispatchAsync(
              ReceiveGroupMessageAction(dto: dto, senderIp: request.ip),
            );
      } else {
        await server.ref.redux(chatProvider).dispatchAsync(
              ReceiveChatMessageAction(dto: dto, senderIp: request.ip),
            );
      }

      return await request.respondJson(200);
    } catch (e) {
      _logger.severe('Failed to deliver chat message', e);
      return await request.respondJson(500, message: 'Internal server error');
    }
  }
}

