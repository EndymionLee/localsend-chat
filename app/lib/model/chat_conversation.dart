import 'package:dart_mappable/dart_mappable.dart';
import 'package:localsend_app/model/chat_message.dart';

part 'chat_conversation.mapper.dart';

@MappableClass()
class ChatConversation with ChatConversationMappable {
  /// Device fingerprint (unique identifier for this conversation).
  final String deviceFingerprint;

  /// Device alias / display name.
  final String deviceAlias;

  /// Device IP address.
  final String deviceIp;

  /// Device port.
  final int devicePort;

  /// Whether the device uses HTTPS.
  final bool deviceHttps;

  /// All messages in this conversation.
  final List<ChatMessage> messages;

  /// Timestamp of the last activity.
  final DateTime lastActivity;

  const ChatConversation({
    required this.deviceFingerprint,
    required this.deviceAlias,
    required this.deviceIp,
    required this.devicePort,
    required this.deviceHttps,
    required this.messages,
    required this.lastActivity,
  });

  /// The most recent message in this conversation.
  ChatMessage? get lastMessage => messages.isNotEmpty ? messages.last : null;

  static const fromJson = ChatConversationMapper.fromJson;
}
