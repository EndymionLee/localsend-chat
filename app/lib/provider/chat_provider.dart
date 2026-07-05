import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:common/model/dto/chat_message_dto.dart';
import 'package:localsend_app/model/chat_message.dart';
import 'package:localsend_app/model/chat_conversation.dart';
import 'package:localsend_app/model/chat_group.dart';
import 'package:localsend_app/provider/persistence_provider.dart';
import 'package:logging/logging.dart';
import 'package:refena_flutter/refena_flutter.dart';
import 'package:uuid/uuid.dart';

final _logger = Logger('ChatProvider');
const _uuid = Uuid();

final chatProvider = ReduxProvider<ChatService, List<ChatConversation>>(
  (ref) => ChatService(ref.read(persistenceProvider)),
);

final chatGroupProvider = ReduxProvider<ChatGroupService, List<ChatGroup>>(
  (ref) => ChatGroupService(ref.read(persistenceProvider)),
);

class ChatService extends ReduxNotifier<List<ChatConversation>> {
  final PersistenceService _persistence;
  ChatService(this._persistence);

  @override
  List<ChatConversation> init() => _persistence.getChatHistory();
}

class ChatGroupService extends ReduxNotifier<List<ChatGroup>> {
  final PersistenceService _persistence;
  ChatGroupService(this._persistence);

  @override
  List<ChatGroup> init() => _persistence.getChatGroupHistory();
}

/// Send a 1:1 chat message.
class SendChatMessageAction extends AsyncReduxAction<ChatService, List<ChatConversation>> {
  final String deviceFingerprint, deviceAlias, deviceIp, message;
  final int devicePort;
  final bool deviceHttps;
  final String? fileName, fileType;
  final int? fileSize;
  final String? fileData;

  SendChatMessageAction({
    required this.deviceFingerprint, required this.deviceAlias, required this.deviceIp,
    required this.devicePort, required this.deviceHttps, required this.message,
    this.fileName, this.fileSize, this.fileType, this.fileData,
  });

  @override
  Future<List<ChatConversation>> reduce() async {
    final conv = state.firstWhereOrNull((c) => c.deviceFingerprint == deviceFingerprint);
    final msg = ChatMessage(
      id: _uuid.v4(), message: message, isFromMe: true, timestamp: DateTime.now(),
      senderAlias: '', fileName: fileName, fileSize: fileSize, fileType: fileType,
      fileData: fileData,
    );
    final updated = <ChatConversation>[];
    if (conv != null) {
      updated.add(conv.copyWith(messages: [...conv.messages, msg], lastActivity: msg.timestamp,
        deviceAlias: deviceAlias, deviceIp: deviceIp, devicePort: devicePort, deviceHttps: deviceHttps));
    } else {
      updated.add(ChatConversation(
        deviceFingerprint: deviceFingerprint, deviceAlias: deviceAlias, deviceIp: deviceIp,
        devicePort: devicePort, deviceHttps: deviceHttps, messages: [msg], lastActivity: msg.timestamp));
    }
    for (final c in state) { if (c.deviceFingerprint != deviceFingerprint) updated.add(c); }
    final result = List<ChatConversation>.unmodifiable(updated);
    notifier._persistence.setChatHistory(result); // ignore: discarded_futures
    return result;
  }
}

/// Receive a chat message (1:1 or group).
class ReceiveChatMessageAction extends AsyncReduxAction<ChatService, List<ChatConversation>> {
  final ChatMessageDto dto;
  final String senderIp;

  ReceiveChatMessageAction({required this.dto, required this.senderIp});

  @override
  Future<List<ChatConversation>> reduce() async {
    // Group messages are handled by ChatController directly via chatGroupProvider.
    if (dto.groupId != null) {
      return state;
    }

    final conv = state.firstWhereOrNull((c) => c.deviceFingerprint == dto.senderFingerprint);
    final msg = ChatMessage(
      id: _uuid.v4(), message: dto.message, isFromMe: false,
      timestamp: DateTime.fromMillisecondsSinceEpoch(dto.timestamp),
      senderAlias: dto.senderAlias, fileName: dto.fileName, fileSize: dto.fileSize,
      fileType: dto.fileType, fileData: dto.fileData,
    );
    final updated = <ChatConversation>[];
    if (conv != null) {
      updated.add(conv.copyWith(messages: [...conv.messages, msg], lastActivity: msg.timestamp, deviceAlias: dto.senderAlias, deviceIp: senderIp));
    } else {
      updated.add(ChatConversation(
        deviceFingerprint: dto.senderFingerprint, deviceAlias: dto.senderAlias, deviceIp: senderIp,
        devicePort: 53317, deviceHttps: false, messages: [msg], lastActivity: msg.timestamp));
    }
    for (final c in state) { if (c.deviceFingerprint != dto.senderFingerprint) updated.add(c); }
    final result = List<ChatConversation>.unmodifiable(updated);
    await notifier._persistence.setChatHistory(result);
    return result;
  }
}

class DeleteConversationAction extends AsyncReduxAction<ChatService, List<ChatConversation>> {
  final String deviceFingerprint;
  DeleteConversationAction(this.deviceFingerprint);
  @override
  Future<List<ChatConversation>> reduce() async {
    final updated = state.where((c) => c.deviceFingerprint != deviceFingerprint).toList();
    await notifier._persistence.setChatHistory(updated);
    return updated;
  }
}

// ---- Group Chat Actions ----

class CreateGroupAction extends AsyncReduxAction<ChatGroupService, List<ChatGroup>> {
  final String name;
  final String adminFingerprint;
  final String adminAlias;
  final String adminIp;
  final int adminPort;
  final bool adminHttps;
  final List<ChatGroupMember> members;

  CreateGroupAction({
    required this.name, required this.adminFingerprint, required this.adminAlias,
    required this.adminIp, required this.adminPort, required this.adminHttps,
    required this.members,
  });

  @override
  Future<List<ChatGroup>> reduce() async {
    final group = ChatGroup(
      id: _uuid.v4(), name: name, adminFingerprint: adminFingerprint,
      members: members, messages: const [], createdAt: DateTime.now(), lastActivity: DateTime.now(),
    );
    final updated = [...state, group];
    await notifier._persistence.setChatGroupHistory(updated);
    return updated;
  }
}

class SendGroupMessageAction extends AsyncReduxAction<ChatGroupService, List<ChatGroup>> {
  final String groupId, message;
  final String? fileName, fileType;
  final int? fileSize;
  final String? fileData;

  SendGroupMessageAction({
    required this.groupId, required this.message,
    this.fileName, this.fileSize, this.fileType, this.fileData,
  });

  @override
  Future<List<ChatGroup>> reduce() async {
    final idx = state.indexWhere((g) => g.id == groupId);
    if (idx == -1) return state;

    final msg = ChatMessage(
      id: _uuid.v4(), message: message, isFromMe: true, timestamp: DateTime.now(),
      senderAlias: '', groupId: groupId,
      fileName: fileName, fileSize: fileSize, fileType: fileType, fileData: fileData,
    );

    final updated = List<ChatGroup>.from(state);
    updated[idx] = updated[idx].copyWith(
      messages: [...updated[idx].messages, msg],
      lastActivity: msg.timestamp,
    );
    await notifier._persistence.setChatGroupHistory(updated);
    return updated;
  }
}

class ReceiveGroupMessageAction extends AsyncReduxAction<ChatGroupService, List<ChatGroup>> {
  final ChatMessageDto dto;
  final String senderIp;
  ReceiveGroupMessageAction({required this.dto, required this.senderIp});

  @override
  Future<List<ChatGroup>> reduce() async {
    var idx = state.indexWhere((g) => g.id == dto.groupId);
    final updated = List<ChatGroup>.from(state);

    if (idx == -1) {
      // Auto-create group if we receive a message for an unknown group.
      // This happens when another user adds us to their group.
      final newGroup = ChatGroup(
        id: dto.groupId!, name: 'Group (${dto.senderAlias})',
        adminFingerprint: dto.senderFingerprint,
        members: [ChatGroupMember(fingerprint: dto.senderFingerprint, alias: dto.senderAlias, ip: senderIp, port: 53317, https: false)],
        messages: const [], createdAt: DateTime.now(), lastActivity: DateTime.now(),
      );
      updated.add(newGroup);
      idx = updated.length - 1;
    }

    final msg = ChatMessage(
      id: _uuid.v4(), message: dto.message, isFromMe: false,
      timestamp: DateTime.fromMillisecondsSinceEpoch(dto.timestamp),
      senderAlias: dto.senderAlias, groupId: dto.groupId,
      fileName: dto.fileName, fileSize: dto.fileSize, fileType: dto.fileType,
      fileData: dto.fileData,
    );

    updated[idx] = updated[idx].copyWith(
      messages: [...updated[idx].messages, msg],
      lastActivity: msg.timestamp,
    );
    await notifier._persistence.setChatGroupHistory(updated);
    return updated;
  }
}

class AddGroupMembersAction extends AsyncReduxAction<ChatGroupService, List<ChatGroup>> {
  final String groupId;
  final List<ChatGroupMember> newMembers;

  AddGroupMembersAction({required this.groupId, required this.newMembers});

  @override
  Future<List<ChatGroup>> reduce() async {
    final idx = state.indexWhere((g) => g.id == groupId);
    if (idx == -1) return state;
    final existing = state[idx];
    final updatedMembers = [...existing.members];
    for (final m in newMembers) {
      if (!updatedMembers.any((em) => em.fingerprint == m.fingerprint)) {
        updatedMembers.add(m);
      }
    }
    final updated = List<ChatGroup>.from(state);
    updated[idx] = updated[idx].copyWith(members: updatedMembers);
    await notifier._persistence.setChatGroupHistory(updated);
    return updated;
  }
}

class RemoveGroupMemberAction extends AsyncReduxAction<ChatGroupService, List<ChatGroup>> {
  final String groupId;
  final String memberFingerprint;

  RemoveGroupMemberAction({required this.groupId, required this.memberFingerprint});

  @override
  Future<List<ChatGroup>> reduce() async {
    final idx = state.indexWhere((g) => g.id == groupId);
    if (idx == -1) return state;
    final updated = List<ChatGroup>.from(state);
    updated[idx] = updated[idx].copyWith(
      members: updated[idx].members.where((m) => m.fingerprint != memberFingerprint).toList(),
    );
    await notifier._persistence.setChatGroupHistory(updated);
    return updated;
  }
}

class DeleteGroupAction extends AsyncReduxAction<ChatGroupService, List<ChatGroup>> {
  final String groupId;
  DeleteGroupAction(this.groupId);
  @override
  Future<List<ChatGroup>> reduce() async {
    final updated = state.where((g) => g.id != groupId).toList();
    await notifier._persistence.setChatGroupHistory(updated);
    return updated;
  }
}

class MarkFileDownloadedAction extends AsyncReduxAction<ChatGroupService, List<ChatGroup>> {
  final String groupId;
  final String messageId;
  final String filePath;

  MarkFileDownloadedAction({required this.groupId, required this.messageId, required this.filePath});

  @override
  Future<List<ChatGroup>> reduce() async {
    final gIdx = state.indexWhere((g) => g.id == groupId);
    if (gIdx == -1) return state;
    final group = state[gIdx];
    final mIdx = group.messages.indexWhere((m) => m.id == messageId);
    if (mIdx == -1) return state;
    final updatedMessages = List<ChatMessage>.from(group.messages);
    updatedMessages[mIdx] = updatedMessages[mIdx].copyWith(filePath: filePath, fileDownloaded: true);
    final updated = List<ChatGroup>.from(state);
    updated[gIdx] = updated[gIdx].copyWith(messages: updatedMessages);
    await notifier._persistence.setChatGroupHistory(updated);
    return updated;
  }
}
