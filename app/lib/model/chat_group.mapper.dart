// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'chat_group.dart';

class ChatGroupMemberMapper extends ClassMapperBase<ChatGroupMember> {
  ChatGroupMemberMapper._();

  static ChatGroupMemberMapper? _instance;
  static ChatGroupMemberMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatGroupMemberMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ChatGroupMember';

  static String _$fingerprint(ChatGroupMember v) => v.fingerprint;
  static const Field<ChatGroupMember, String> _f$fingerprint = Field(
    'fingerprint',
    _$fingerprint,
  );
  static String _$alias(ChatGroupMember v) => v.alias;
  static const Field<ChatGroupMember, String> _f$alias = Field(
    'alias',
    _$alias,
  );
  static String _$ip(ChatGroupMember v) => v.ip;
  static const Field<ChatGroupMember, String> _f$ip = Field('ip', _$ip);
  static int _$port(ChatGroupMember v) => v.port;
  static const Field<ChatGroupMember, int> _f$port = Field('port', _$port);
  static bool _$https(ChatGroupMember v) => v.https;
  static const Field<ChatGroupMember, bool> _f$https = Field('https', _$https);

  @override
  final MappableFields<ChatGroupMember> fields = const {
    #fingerprint: _f$fingerprint,
    #alias: _f$alias,
    #ip: _f$ip,
    #port: _f$port,
    #https: _f$https,
  };

  static ChatGroupMember _instantiate(DecodingData data) {
    return ChatGroupMember(
      fingerprint: data.dec(_f$fingerprint),
      alias: data.dec(_f$alias),
      ip: data.dec(_f$ip),
      port: data.dec(_f$port),
      https: data.dec(_f$https),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ChatGroupMember fromJson(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChatGroupMember>(map);
  }

  static ChatGroupMember deserialize(String json) {
    return ensureInitialized().decodeJson<ChatGroupMember>(json);
  }
}

mixin ChatGroupMemberMappable {
  String serialize() {
    return ChatGroupMemberMapper.ensureInitialized()
        .encodeJson<ChatGroupMember>(this as ChatGroupMember);
  }

  Map<String, dynamic> toJson() {
    return ChatGroupMemberMapper.ensureInitialized().encodeMap<ChatGroupMember>(
      this as ChatGroupMember,
    );
  }

  ChatGroupMemberCopyWith<ChatGroupMember, ChatGroupMember, ChatGroupMember>
  get copyWith =>
      _ChatGroupMemberCopyWithImpl<ChatGroupMember, ChatGroupMember>(
        this as ChatGroupMember,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ChatGroupMemberMapper.ensureInitialized().stringifyValue(
      this as ChatGroupMember,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChatGroupMemberMapper.ensureInitialized().equalsValue(
      this as ChatGroupMember,
      other,
    );
  }

  @override
  int get hashCode {
    return ChatGroupMemberMapper.ensureInitialized().hashValue(
      this as ChatGroupMember,
    );
  }
}

extension ChatGroupMemberValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ChatGroupMember, $Out> {
  ChatGroupMemberCopyWith<$R, ChatGroupMember, $Out> get $asChatGroupMember =>
      $base.as((v, t, t2) => _ChatGroupMemberCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ChatGroupMemberCopyWith<$R, $In extends ChatGroupMember, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? fingerprint,
    String? alias,
    String? ip,
    int? port,
    bool? https,
  });
  ChatGroupMemberCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ChatGroupMemberCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChatGroupMember, $Out>
    implements ChatGroupMemberCopyWith<$R, ChatGroupMember, $Out> {
  _ChatGroupMemberCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChatGroupMember> $mapper =
      ChatGroupMemberMapper.ensureInitialized();
  @override
  $R call({
    String? fingerprint,
    String? alias,
    String? ip,
    int? port,
    bool? https,
  }) => $apply(
    FieldCopyWithData({
      if (fingerprint != null) #fingerprint: fingerprint,
      if (alias != null) #alias: alias,
      if (ip != null) #ip: ip,
      if (port != null) #port: port,
      if (https != null) #https: https,
    }),
  );
  @override
  ChatGroupMember $make(CopyWithData data) => ChatGroupMember(
    fingerprint: data.get(#fingerprint, or: $value.fingerprint),
    alias: data.get(#alias, or: $value.alias),
    ip: data.get(#ip, or: $value.ip),
    port: data.get(#port, or: $value.port),
    https: data.get(#https, or: $value.https),
  );

  @override
  ChatGroupMemberCopyWith<$R2, ChatGroupMember, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChatGroupMemberCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ChatGroupMapper extends ClassMapperBase<ChatGroup> {
  ChatGroupMapper._();

  static ChatGroupMapper? _instance;
  static ChatGroupMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatGroupMapper._());
      ChatGroupMemberMapper.ensureInitialized();
      ChatMessageMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ChatGroup';

  static String _$id(ChatGroup v) => v.id;
  static const Field<ChatGroup, String> _f$id = Field('id', _$id);
  static String _$name(ChatGroup v) => v.name;
  static const Field<ChatGroup, String> _f$name = Field('name', _$name);
  static List<ChatGroupMember> _$members(ChatGroup v) => v.members;
  static const Field<ChatGroup, List<ChatGroupMember>> _f$members = Field(
    'members',
    _$members,
  );
  static String _$adminFingerprint(ChatGroup v) => v.adminFingerprint;
  static const Field<ChatGroup, String> _f$adminFingerprint = Field(
    'adminFingerprint',
    _$adminFingerprint,
  );
  static List<ChatMessage> _$messages(ChatGroup v) => v.messages;
  static const Field<ChatGroup, List<ChatMessage>> _f$messages = Field(
    'messages',
    _$messages,
  );
  static DateTime _$createdAt(ChatGroup v) => v.createdAt;
  static const Field<ChatGroup, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );
  static DateTime _$lastActivity(ChatGroup v) => v.lastActivity;
  static const Field<ChatGroup, DateTime> _f$lastActivity = Field(
    'lastActivity',
    _$lastActivity,
  );
  static ChatGroupMember? _$lastMessage(ChatGroup v) => v.lastMessage;
  static const Field<ChatGroup, ChatGroupMember> _f$lastMessage = Field(
    'lastMessage',
    _$lastMessage,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<ChatGroup> fields = const {
    #id: _f$id,
    #name: _f$name,
    #members: _f$members,
    #adminFingerprint: _f$adminFingerprint,
    #messages: _f$messages,
    #createdAt: _f$createdAt,
    #lastActivity: _f$lastActivity,
    #lastMessage: _f$lastMessage,
  };

  static ChatGroup _instantiate(DecodingData data) {
    return ChatGroup(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      members: data.dec(_f$members),
      adminFingerprint: data.dec(_f$adminFingerprint),
      messages: data.dec(_f$messages),
      createdAt: data.dec(_f$createdAt),
      lastActivity: data.dec(_f$lastActivity),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ChatGroup fromJson(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChatGroup>(map);
  }

  static ChatGroup deserialize(String json) {
    return ensureInitialized().decodeJson<ChatGroup>(json);
  }
}

mixin ChatGroupMappable {
  String serialize() {
    return ChatGroupMapper.ensureInitialized().encodeJson<ChatGroup>(
      this as ChatGroup,
    );
  }

  Map<String, dynamic> toJson() {
    return ChatGroupMapper.ensureInitialized().encodeMap<ChatGroup>(
      this as ChatGroup,
    );
  }

  ChatGroupCopyWith<ChatGroup, ChatGroup, ChatGroup> get copyWith =>
      _ChatGroupCopyWithImpl<ChatGroup, ChatGroup>(
        this as ChatGroup,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ChatGroupMapper.ensureInitialized().stringifyValue(
      this as ChatGroup,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChatGroupMapper.ensureInitialized().equalsValue(
      this as ChatGroup,
      other,
    );
  }

  @override
  int get hashCode {
    return ChatGroupMapper.ensureInitialized().hashValue(this as ChatGroup);
  }
}

extension ChatGroupValueCopy<$R, $Out> on ObjectCopyWith<$R, ChatGroup, $Out> {
  ChatGroupCopyWith<$R, ChatGroup, $Out> get $asChatGroup =>
      $base.as((v, t, t2) => _ChatGroupCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ChatGroupCopyWith<$R, $In extends ChatGroup, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    ChatGroupMember,
    ChatGroupMemberCopyWith<$R, ChatGroupMember, ChatGroupMember>
  >
  get members;
  ListCopyWith<
    $R,
    ChatMessage,
    ChatMessageCopyWith<$R, ChatMessage, ChatMessage>
  >
  get messages;
  $R call({
    String? id,
    String? name,
    List<ChatGroupMember>? members,
    String? adminFingerprint,
    List<ChatMessage>? messages,
    DateTime? createdAt,
    DateTime? lastActivity,
  });
  ChatGroupCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ChatGroupCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChatGroup, $Out>
    implements ChatGroupCopyWith<$R, ChatGroup, $Out> {
  _ChatGroupCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChatGroup> $mapper =
      ChatGroupMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    ChatGroupMember,
    ChatGroupMemberCopyWith<$R, ChatGroupMember, ChatGroupMember>
  >
  get members => ListCopyWith(
    $value.members,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(members: v),
  );
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
    String? id,
    String? name,
    List<ChatGroupMember>? members,
    String? adminFingerprint,
    List<ChatMessage>? messages,
    DateTime? createdAt,
    DateTime? lastActivity,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (members != null) #members: members,
      if (adminFingerprint != null) #adminFingerprint: adminFingerprint,
      if (messages != null) #messages: messages,
      if (createdAt != null) #createdAt: createdAt,
      if (lastActivity != null) #lastActivity: lastActivity,
    }),
  );
  @override
  ChatGroup $make(CopyWithData data) => ChatGroup(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    members: data.get(#members, or: $value.members),
    adminFingerprint: data.get(#adminFingerprint, or: $value.adminFingerprint),
    messages: data.get(#messages, or: $value.messages),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    lastActivity: data.get(#lastActivity, or: $value.lastActivity),
  );

  @override
  ChatGroupCopyWith<$R2, ChatGroup, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChatGroupCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

