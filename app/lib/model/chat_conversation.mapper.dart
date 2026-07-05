// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'chat_conversation.dart';

class ChatConversationMapper extends ClassMapperBase<ChatConversation> {
  ChatConversationMapper._();

  static ChatConversationMapper? _instance;
  static ChatConversationMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatConversationMapper._());
      ChatMessageMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ChatConversation';

  static String _$deviceFingerprint(ChatConversation v) => v.deviceFingerprint;
  static const Field<ChatConversation, String> _f$deviceFingerprint = Field(
    'deviceFingerprint',
    _$deviceFingerprint,
  );
  static String _$deviceAlias(ChatConversation v) => v.deviceAlias;
  static const Field<ChatConversation, String> _f$deviceAlias = Field(
    'deviceAlias',
    _$deviceAlias,
  );
  static String _$deviceIp(ChatConversation v) => v.deviceIp;
  static const Field<ChatConversation, String> _f$deviceIp = Field(
    'deviceIp',
    _$deviceIp,
  );
  static int _$devicePort(ChatConversation v) => v.devicePort;
  static const Field<ChatConversation, int> _f$devicePort = Field(
    'devicePort',
    _$devicePort,
  );
  static bool _$deviceHttps(ChatConversation v) => v.deviceHttps;
  static const Field<ChatConversation, bool> _f$deviceHttps = Field(
    'deviceHttps',
    _$deviceHttps,
  );
  static List<ChatMessage> _$messages(ChatConversation v) => v.messages;
  static const Field<ChatConversation, List<ChatMessage>> _f$messages = Field(
    'messages',
    _$messages,
  );
  static DateTime _$lastActivity(ChatConversation v) => v.lastActivity;
  static const Field<ChatConversation, DateTime> _f$lastActivity = Field(
    'lastActivity',
    _$lastActivity,
  );
  static ChatMessage? _$lastMessage(ChatConversation v) => v.lastMessage;
  static const Field<ChatConversation, ChatMessage> _f$lastMessage = Field(
    'lastMessage',
    _$lastMessage,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<ChatConversation> fields = const {
    #deviceFingerprint: _f$deviceFingerprint,
    #deviceAlias: _f$deviceAlias,
    #deviceIp: _f$deviceIp,
    #devicePort: _f$devicePort,
    #deviceHttps: _f$deviceHttps,
    #messages: _f$messages,
    #lastActivity: _f$lastActivity,
    #lastMessage: _f$lastMessage,
  };

  static ChatConversation _instantiate(DecodingData data) {
    return ChatConversation(
      deviceFingerprint: data.dec(_f$deviceFingerprint),
      deviceAlias: data.dec(_f$deviceAlias),
      deviceIp: data.dec(_f$deviceIp),
      devicePort: data.dec(_f$devicePort),
      deviceHttps: data.dec(_f$deviceHttps),
      messages: data.dec(_f$messages),
      lastActivity: data.dec(_f$lastActivity),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ChatConversation fromJson(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChatConversation>(map);
  }

  static ChatConversation deserialize(String json) {
    return ensureInitialized().decodeJson<ChatConversation>(json);
  }
}

mixin ChatConversationMappable {
  String serialize() {
    return ChatConversationMapper.ensureInitialized()
        .encodeJson<ChatConversation>(this as ChatConversation);
  }

  Map<String, dynamic> toJson() {
    return ChatConversationMapper.ensureInitialized()
        .encodeMap<ChatConversation>(this as ChatConversation);
  }

  ChatConversationCopyWith<ChatConversation, ChatConversation, ChatConversation>
  get copyWith =>
      _ChatConversationCopyWithImpl<ChatConversation, ChatConversation>(
        this as ChatConversation,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ChatConversationMapper.ensureInitialized().stringifyValue(
      this as ChatConversation,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChatConversationMapper.ensureInitialized().equalsValue(
      this as ChatConversation,
      other,
    );
  }

  @override
  int get hashCode {
    return ChatConversationMapper.ensureInitialized().hashValue(
      this as ChatConversation,
    );
  }
}

extension ChatConversationValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ChatConversation, $Out> {
  ChatConversationCopyWith<$R, ChatConversation, $Out>
  get $asChatConversation =>
      $base.as((v, t, t2) => _ChatConversationCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ChatConversationCopyWith<$R, $In extends ChatConversation, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    ChatMessage,
    ChatMessageCopyWith<$R, ChatMessage, ChatMessage>
  >
  get messages;
  $R call({
    String? deviceFingerprint,
    String? deviceAlias,
    String? deviceIp,
    int? devicePort,
    bool? deviceHttps,
    List<ChatMessage>? messages,
    DateTime? lastActivity,
  });
  ChatConversationCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ChatConversationCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChatConversation, $Out>
    implements ChatConversationCopyWith<$R, ChatConversation, $Out> {
  _ChatConversationCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChatConversation> $mapper =
      ChatConversationMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    ChatMessage,
    ChatMessageCopyWith<$R, ChatMessage, ChatMessage>
  >
  get messages => ListCopyWith(
    $value.messages,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(messages: v),
  );
  @override
  $R call({
    String? deviceFingerprint,
    String? deviceAlias,
    String? deviceIp,
    int? devicePort,
    bool? deviceHttps,
    List<ChatMessage>? messages,
    DateTime? lastActivity,
  }) => $apply(
    FieldCopyWithData({
      if (deviceFingerprint != null) #deviceFingerprint: deviceFingerprint,
      if (deviceAlias != null) #deviceAlias: deviceAlias,
      if (deviceIp != null) #deviceIp: deviceIp,
      if (devicePort != null) #devicePort: devicePort,
      if (deviceHttps != null) #deviceHttps: deviceHttps,
      if (messages != null) #messages: messages,
      if (lastActivity != null) #lastActivity: lastActivity,
    }),
  );
  @override
  ChatConversation $make(CopyWithData data) => ChatConversation(
    deviceFingerprint: data.get(
      #deviceFingerprint,
      or: $value.deviceFingerprint,
    ),
    deviceAlias: data.get(#deviceAlias, or: $value.deviceAlias),
    deviceIp: data.get(#deviceIp, or: $value.deviceIp),
    devicePort: data.get(#devicePort, or: $value.devicePort),
    deviceHttps: data.get(#deviceHttps, or: $value.deviceHttps),
    messages: data.get(#messages, or: $value.messages),
    lastActivity: data.get(#lastActivity, or: $value.lastActivity),
  );

  @override
  ChatConversationCopyWith<$R2, ChatConversation, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChatConversationCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

