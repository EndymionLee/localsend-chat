import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localsend_app/provider/chat_http_client.dart';
import 'package:localsend_app/provider/chat_provider.dart';
import 'package:localsend_app/provider/persistence_provider.dart';
import 'package:localsend_app/provider/security_provider.dart';
import 'package:localsend_app/provider/settings_provider.dart';
import 'package:logging/logging.dart';
import 'package:refena_flutter/refena_flutter.dart';

final _logger = Logger('ClipboardSync');

/// Polls clipboard and broadcasts changes when shared clipboard is enabled.
/// Also broadcasts to all group members.
class ClipboardSyncWatcher extends StatefulWidget {
  final Widget child;
  const ClipboardSyncWatcher({super.key, required this.child});

  @override
  State<ClipboardSyncWatcher> createState() => _ClipboardSyncWatcherState();
}

class _ClipboardSyncWatcherState extends State<ClipboardSyncWatcher> with Refena {
  String? _lastContent;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  void _startPolling() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _checkClipboard());
  }

  Future<void> _checkClipboard() async {
    final settings = ref.read(settingsProvider);
    if (!settings.sharedClipboard) {
      _lastContent = null;
      return;
    }

    try {
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      final content = data?.text;
      if (content == null || content.isEmpty || content == _lastContent) return;
      _lastContent = content;

      final fingerprint = ref.read(securityProvider).certificateHash;
      final settingsData = ref.read(settingsProvider);
      final persistence = ref.read(persistenceProvider);
      final client = ChatHttpClient(persistence.getSecurityContext());

      // Broadcast to all 1:1 conversations.
      final conversations = ref.read(chatProvider);
      for (final conv in conversations) {
        unawaited(client.sendChatMessage(
          targetIp: conv.deviceIp, targetPort: conv.devicePort, targetHttps: conv.deviceHttps,
          message: content, senderAlias: settingsData.alias, senderFingerprint: fingerprint,
          fileName: '__CLIPBOARD__',
        ));
      }

      // Broadcast to all group members.
      final groups = ref.read(chatGroupProvider);
      for (final group in groups) {
        for (final member in group.members) {
          if (member.fingerprint == fingerprint) continue;
          unawaited(client.sendChatMessage(
            targetIp: member.ip, targetPort: member.port, targetHttps: member.https,
            message: content, senderAlias: settingsData.alias, senderFingerprint: fingerprint,
            fileName: '__CLIPBOARD__',
          ));
        }
      }

      _logger.info('Clipboard broadcast: ${content.length > 50 ? '${content.substring(0, 50)}...' : content}');
    } catch (_) {
      // Clipboard might not be accessible.
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
