// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'chat_message_dto.dart';

class ChatMessageDtoMapper extends ClassMapperBase<ChatMessageDto> {
  ChatMessageDtoMapper._();

  static ChatMessageDtoMapper? _instance;
  static ChatMessageDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatMessageDtoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ChatMessageDto';

  static String _$message(ChatMessageDto v) => v.message;
  static const Field<ChatMessageDto, String> _f$message = Field(
    'message',
    _$message,
  );
  static int _$timestamp(ChatMessageDto v) => v.timestamp;
  static const Field<ChatMessageDto, int> _f$timestamp = Field(
    'timestamp',
    _$timestamp,
  );
  static String _$senderAlias(ChatMessageDto v) => v.senderAlias;
  static const Field<ChatMessageDto, String> _f$senderAlias = Field(
    'senderAlias',
    _$senderAlias,
  );
  static String _$senderFingerprint(ChatMessageDto v) => v.senderFingerprint;
  static const Field<ChatMessageDto, String> _f$senderFingerprint = Field(
    'senderFingerprint',
    _$senderFingerprint,
  );
  static String? _$fileName(ChatMessageDto v) => v.fileName;
  static const Field<ChatMessageDto, String> _f$fileName = Field(
    'fileName',
    _$fileName,
    opt: true,
  );
  static int? _$fileSize(ChatMessageDto v) => v.fileSize;
  static const Field<ChatMessageDto, int> _f$fileSize = Field(
    'fileSize',
    _$fileSize,
    opt: true,
  );
  static String? _$fileType(ChatMessageDto v) => v.fileType;
  static const Field<ChatMessageDto, String> _f$fileType = Field(
    'fileType',
    _$fileType,
    opt: true,
  );
  static String? _$groupId(ChatMessageDto v) => v.groupId;
  static const Field<ChatMessageDto, String> _f$groupId = Field(
    'groupId',
    _$groupId,
    opt: true,
  );
  static String? _$fileData(ChatMessageDto v) => v.fileData;
  static const Field<ChatMessageDto, String> _f$fileData = Field(
    'fileData',
    _$fileData,
    opt: true,
  );

  @override
  final MappableFields<ChatMessageDto> fields = const {
    #message: _f$message,
    #timestamp: _f$timestamp,
    #senderAlias: _f$senderAlias,
    #senderFingerprint: _f$senderFingerprint,
    #groupId: _f$groupId,
    #fileName: _f$fileName,
    #fileSize: _f$fileSize,
    #fileType: _f$fileType,
    #fileData: _f$fileData,
  };

  static ChatMessageDto _instantiate(DecodingData data) {
    return ChatMessageDto(
      message: data.dec(_f$message),
      timestamp: data.dec(_f$timestamp),
      senderAlias: data.dec(_f$senderAlias),
      senderFingerprint: data.dec(_f$senderFingerprint),
      groupId: data.dec(_f$groupId),
      fileName: data.dec(_f$fileName),
      fileSize: data.dec(_f$fileSize),
      fileType: data.dec(_f$fileType),
      fileData: data.dec(_f$fileData),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ChatMessageDto fromJson(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChatMessageDto>(map);
  }

  static ChatMessageDto deserialize(String json) {
    return ensureInitialized().decodeJson<ChatMessageDto>(json);
  }
}

mixin ChatMessageDtoMappable {
  String serialize() {
    return ChatMessageDtoMapper.ensureInitialized().encodeJson<ChatMessageDto>(
      this as ChatMessageDto,
    );
  }

  Map<String, dynamic> toJson() {
    return ChatMessageDtoMapper.ensureInitialized().encodeMap<ChatMessageDto>(
      this as ChatMessageDto,
    );
  }

  ChatMessageDtoCopyWith<ChatMessageDto, ChatMessageDto, ChatMessageDto>
  get copyWith => _ChatMessageDtoCopyWithImpl<ChatMessageDto, ChatMessageDto>(
    this as ChatMessageDto,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return ChatMessageDtoMapper.ensureInitialized().stringifyValue(
      this as ChatMessageDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChatMessageDtoMapper.ensureInitialized().equalsValue(
      this as ChatMessageDto,
      other,
    );
  }

  @override
  int get hashCode {
    return ChatMessageDtoMapper.ensureInitialized().hashValue(
      this as ChatMessageDto,
    );
  }
}

extension ChatMessageDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ChatMessageDto, $Out> {
  ChatMessageDtoCopyWith<$R, ChatMessageDto, $Out> get $asChatMessageDto =>
      $base.as((v, t, t2) => _ChatMessageDtoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ChatMessageDtoCopyWith<$R, $In extends ChatMessageDto, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? message,
    int? timestamp,
    String? senderAlias,
    String? senderFingerprint,
    String? fileName,
    int? fileSize,
    String? fileType,
  });
  ChatMessageDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ChatMessageDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChatMessageDto, $Out>
    implements ChatMessageDtoCopyWith<$R, ChatMessageDto, $Out> {
  _ChatMessageDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChatMessageDto> $mapper =
      ChatMessageDtoMapper.ensureInitialized();
  @override
  $R call({
    String? message,
    int? timestamp,
    String? senderAlias,
    String? senderFingerprint,
    Object? groupId = $none,
    Object? fileName = $none,
    Object? fileSize = $none,
    Object? fileType = $none,
    Object? fileData = $none,
  }) => $apply(
    FieldCopyWithData({
      if (message != null) #message: message,
      if (timestamp != null) #timestamp: timestamp,
      if (senderAlias != null) #senderAlias: senderAlias,
      if (senderFingerprint != null) #senderFingerprint: senderFingerprint,
      if (groupId != $none) #groupId: groupId,
      if (fileName != $none) #fileName: fileName,
      if (fileSize != $none) #fileSize: fileSize,
      if (fileType != $none) #fileType: fileType,
      if (fileData != $none) #fileData: fileData,
    }),
  );
  @override
  ChatMessageDto $make(CopyWithData data) => ChatMessageDto(
    message: data.get(#message, or: $value.message),
    timestamp: data.get(#timestamp, or: $value.timestamp),
    senderAlias: data.get(#senderAlias, or: $value.senderAlias),
    senderFingerprint: data.get(#senderFingerprint, or: $value.senderFingerprint),
    groupId: data.get(#groupId, or: $value.groupId),
    fileName: data.get(#fileName, or: $value.fileName),
    fileSize: data.get(#fileSize, or: $value.fileSize),
    fileType: data.get(#fileType, or: $value.fileType),
    fileData: data.get(#fileData, or: $value.fileData),
  );

  @override
  ChatMessageDtoCopyWith<$R2, ChatMessageDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChatMessageDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

