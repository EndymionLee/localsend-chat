import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:localsend_app/gen/strings.g.dart';
import 'package:localsend_app/model/chat_message.dart';
import 'package:localsend_app/model/chat_group.dart';
import 'package:localsend_app/provider/chat_http_client.dart';
import 'package:localsend_app/provider/chat_provider.dart';
import 'package:localsend_app/provider/network/nearby_devices_provider.dart';
import 'package:localsend_app/provider/persistence_provider.dart';
import 'package:localsend_app/provider/security_provider.dart';
import 'package:localsend_app/provider/settings_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:refena_flutter/refena_flutter.dart';

class ChatPage extends StatefulWidget {
  /// For 1:1 chat, pass [fingerprint] and [alias].
  final String? fingerprint;
  final String? alias;
  final String? ip;
  final int? port;
  final bool? https;

  /// For group chat, pass [group].
  final ChatGroup? group;

  const ChatPage({super.key, this.fingerprint, this.alias, this.ip, this.port, this.https, this.group});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with Refena {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSending = false;

  bool get _isGroup => widget.group != null;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
      }
    });
  }

  Future<void> _sendMessage({String? fileName, int? fileSize, String? fileType, Uint8List? fileBytes}) async {
    final text = _textController.text.trim();
    if (text.isEmpty && fileName == null) return;
    setState(() => _isSending = true);
    _textController.clear();

    try {
      final fingerprint = ref.read(securityProvider).certificateHash;
      final settings = ref.read(settingsProvider);
      final persistence = ref.read(persistenceProvider);
      final client = ChatHttpClient(persistence.getSecurityContext());
      final fileDataB64 = fileBytes != null ? base64Encode(fileBytes) : null;

      if (_isGroup) {
        final g = widget.group!;
        // Add to local group state.
        await ref.redux(chatGroupProvider).dispatchAsync(SendGroupMessageAction(
          groupId: g.id, message: text, fileName: fileName, fileSize: fileSize, fileType: fileType, fileData: fileDataB64,
        ));
        // Send to all group members.
        unawaited(client.sendGroupMessage(
          targets: g.members.map((m) => (ip: m.ip, port: m.port, https: m.https)).toList(),
          message: text, senderAlias: settings.alias, senderFingerprint: fingerprint,
          groupId: g.id, fileName: fileName, fileSize: fileSize, fileType: fileType, fileBytes: fileBytes,
        ));
      } else {
        await ref.redux(chatProvider).dispatchAsync(SendChatMessageAction(
          deviceFingerprint: widget.fingerprint!, deviceAlias: widget.alias!, deviceIp: widget.ip!,
          devicePort: widget.port!, deviceHttps: widget.https!, message: text,
          fileName: fileName, fileSize: fileSize, fileType: fileType, fileData: fileDataB64,
        ));
        unawaited(client.sendChatMessage(
          targetIp: widget.ip!, targetPort: widget.port!, targetHttps: widget.https!,
          message: text, senderAlias: settings.alias, senderFingerprint: fingerprint,
          fileName: fileName, fileSize: fileSize, fileType: fileType, fileBytes: fileBytes,
        ));
      }
      _scrollToBottom();
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  Future<void> _pickAndSendFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(allowMultiple: false,
        type: FileType.any,
      );
      if (result != null && result.files.isNotEmpty && mounted) {
        final file = result.files.first;
        Uint8List? bytes;
        if (file.path != null) {
          final f = File(file.path!);
          final fileSize = await f.length();
          // Read thumbnail for images.
          if (file.extension?.toLowerCase() == 'jpg' || file.extension?.toLowerCase() == 'jpeg' ||
              file.extension?.toLowerCase() == 'png' || file.extension?.toLowerCase() == 'gif') {
            if (fileSize < 512 * 1024) {
              bytes = await f.readAsBytes();
            }
          }
          await _sendMessage(fileName: file.name, fileSize: fileSize, fileType: file.extension?.toLowerCase(), fileBytes: bytes);
        }
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
    }
  }

  Future<void> _downloadFile(ChatMessage msg) async {
    // For group messages: the file data might be embedded (small files / images)
    if (msg.fileData != null && !msg.fileDownloaded) {
      final bytes = msg.fileBytes!;
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/${msg.fileName}';
      final f = File(filePath);
      await f.writeAsBytes(bytes);
      if (_isGroup) {
        await ref.redux(chatGroupProvider).dispatchAsync(MarkFileDownloadedAction(
          groupId: widget.group!.id, messageId: msg.id, filePath: filePath,
        ));
      }
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved to Downloads'), duration: Duration(seconds: 1)));
    }
  }

  void _openFile(ChatMessage msg) {
    if (msg.filePath != null) {
      OpenFilex.open(msg.filePath!);
    } else if (msg.fileData != null) {
      _downloadFile(msg).then((_) {
        if (msg.filePath != null) OpenFilex.open(msg.filePath!);
      });
    }
  }

  List<ChatMessage> get _messages {
    if (_isGroup) {
      final groups = ref.watch(chatGroupProvider);
      final g = groups.firstWhereOrNull((g) => g.id == widget.group!.id);
      return g?.messages ?? [];
    } else {
      final conversations = ref.watch(chatProvider);
      final conv = conversations.firstWhereOrNull((c) => c.deviceFingerprint == widget.fingerprint);
      return conv?.messages ?? [];
    }
  }

  String get _title => _isGroup ? widget.group!.name : widget.alias ?? '';

  @override
  Widget build(BuildContext context) {
    final messages = _messages;
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        leading: const BackButton(),
        actions: [
          if (_isGroup)
            IconButton(
              icon: const Icon(Icons.group_add),
              tooltip: 'Add members',
              onPressed: _addMembers,
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? Center(child: Text(t.chatTab.noConversations, style: Theme.of(context).textTheme.bodyMedium))
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemCount: messages.length,
                    itemBuilder: (_, i) => _ChatBubble(message: messages[i], onDownload: _downloadFile, onOpen: _openFile),
                  ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  void _addMembers() {
    // Quick: pick from nearby devices
    final devices = ref.read(nearbyDevicesProvider);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Members'),
        content: SizedBox(
          width: 300,
          child: ListView(
            shrinkWrap: true,
            children: devices.allDevices.values.map((d) {
              final isMember = widget.group!.members.any((m) => m.fingerprint == d.fingerprint);
              return ListTile(
                title: Text(d.alias),
                subtitle: Text(d.ip ?? ''),
                trailing: isMember ? const Icon(Icons.check, color: Colors.green) : const Icon(Icons.add),
                enabled: !isMember,
                onTap: isMember ? null : () {
                  ref.redux(chatGroupProvider).dispatchAsync(AddGroupMembersAction(
                    groupId: widget.group!.id,
                    newMembers: [ChatGroupMember(fingerprint: d.fingerprint, alias: d.alias, ip: d.ip!, port: d.port, https: d.https)],
                  ));
                  Navigator.pop(ctx);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 4, offset: const Offset(0, -1))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(icon: const Icon(Icons.attach_file), onPressed: _pickAndSendFile, tooltip: t.chatTab.attachFile),
            Expanded(
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: t.chatTab.inputHint,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                  filled: true, fillColor: Theme.of(context).colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                textInputAction: TextInputAction.send, maxLines: 4, minLines: 1,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: _isSending ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.send),
              onPressed: _isSending ? null : () => _sendMessage(),
              tooltip: t.chatTab.send,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final void Function(ChatMessage) onDownload;
  final void Function(ChatMessage) onOpen;

  const _ChatBubble({required this.message, required this.onDownload, required this.onOpen});

  void _copyMessage(BuildContext context) {
    Clipboard.setData(ClipboardData(text: message.message));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied'), duration: Duration(seconds: 1), behavior: SnackBarBehavior.floating, width: 100));
  }

  @override
  Widget build(BuildContext context) {
    final isMe = message.isFromMe;
    final bubbleColor = isMe ? Theme.of(context).colorScheme.primary : Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.white;
    final textColor = isMe ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(radius: 14, backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(message.senderAlias.isNotEmpty ? message.senderAlias[0].toUpperCase() : '?',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryContainer))),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
              decoration: BoxDecoration(color: bubbleColor, borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 2, offset: const Offset(0, 1))]),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                // File attachment area (left side = download, right side = open)
                if (message.hasFile) _buildFileCard(context, textColor, isMe),
                // Text message
                if (message.message.isNotEmpty)
                  SelectableText(message.message, style: TextStyle(color: textColor, fontSize: 15, height: 1.4)),
                const SizedBox(height: 4),
                // Timestamp + copy
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(DateFormat.Hm().format(message.timestamp.toLocal()),
                    style: TextStyle(fontSize: 11, color: textColor.withValues(alpha: 0.55))),
                  const SizedBox(width: 6),
                  InkWell(onTap: () => _copyMessage(context), borderRadius: BorderRadius.circular(10),
                    child: Padding(padding: const EdgeInsets.all(2), child: Icon(Icons.copy, size: 13, color: textColor.withValues(alpha: 0.5)))),
                ]),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileCard(BuildContext context, Color textColor, bool isMe) {
    if (message.isImage) {
      // Image: show preview inline
      if (message.fileBytes != null) {
        return GestureDetector(
          onTap: () => onOpen(message),
          child: Container(
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            clipBehavior: Clip.antiAlias,
            child: Image.memory(message.fileBytes!, fit: BoxFit.cover, width: 200, height: 150,
              errorBuilder: (_, __, ___) => _fileInfoCard(context, textColor, isMe)),
          ),
        );
      }
      return _fileInfoCard(context, textColor, isMe);
    }

    if (message.isVideo) {
      // Video: show play button, click to open
      return GestureDetector(
        onTap: () => onOpen(message),
        child: Container(
          margin: const EdgeInsets.only(bottom: 6), padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(10)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.play_circle_fill, size: 28, color: textColor),
            const SizedBox(width: 8),
            Flexible(child: Text(message.fileName ?? 'Video', style: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 14), overflow: TextOverflow.ellipsis)),
          ]),
        ),
      );
    }

    return _fileInfoCard(context, textColor, isMe);
  }

  Widget _fileInfoCard(BuildContext context, Color textColor, bool isMe) {
    return GestureDetector(
      onTap: () {
        if (message.fileDownloaded) {
          onOpen(message);
        } else {
          onDownload(message);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 6), padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: (isMe ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.surfaceContainerHighest).withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(10)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(message.fileDownloaded ? Icons.check_circle : Icons.download, size: 22, color: textColor),
          const SizedBox(width: 8),
          Flexible(child: Text(message.fileName ?? '', style: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 14), overflow: TextOverflow.ellipsis)),
          if (message.fileSize != null) ...[
            const SizedBox(width: 8),
            Text(_formatSize(message.fileSize!), style: TextStyle(color: textColor.withValues(alpha: 0.6), fontSize: 12)),
          ],
        ]),
      ),
    );
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
