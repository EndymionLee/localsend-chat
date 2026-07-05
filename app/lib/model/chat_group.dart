import 'package:dart_mappable/dart_mappable.dart';
import 'package:localsend_app/model/chat_message.dart';

part 'chat_group.mapper.dart';

@MappableClass()
class ChatGroupMember with ChatGroupMemberMappable {
  final String fingerprint;
  final String alias;
  final String ip;
  final int port;
  final bool https;

  const ChatGroupMember({
    required this.fingerprint,
    required this.alias,
    required this.ip,
    required this.port,
    required this.https,
  });

  static const fromJson = ChatGroupMemberMapper.fromJson;
}

@MappableClass()
class ChatGroup with ChatGroupMappable {
  /// Unique group ID.
  final String id;

  /// Group name.
  final String name;

  /// Group members.
  final List<ChatGroupMember> members;

  /// Admin fingerprint (creator).
  final String adminFingerprint;

  /// Group chat messages.
  final List<ChatMessage> messages;

  /// When the group was created.
  final DateTime createdAt;

  /// Last activity timestamp.
  final DateTime lastActivity;

  const ChatGroup({
    required this.id,
    required this.name,
    required this.members,
    required this.adminFingerprint,
    required this.messages,
    required this.createdAt,
    required this.lastActivity,
  });

  ChatGroupMember? get lastMessage => null;

  bool isAdmin(String fingerprint) => adminFingerprint == fingerprint;

  static const fromJson = ChatGroupMapper.fromJson;
}
