// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'chat_message.dart';

class ChatMessageMapper extends ClassMapperBase<ChatMessage> {
  ChatMessageMapper._();

  static ChatMessageMapper? _instance;
  static ChatMessageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatMessageMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ChatMessage';

  static String _$id(ChatMessage v) => v.id;
  static const Field<ChatMessage, String> _f$id = Field('id', _$id);
  static String _$message(ChatMessage v) => v.message;
  static const Field<ChatMessage, String> _f$message = Field(
    'message',
    _$message,
  );
  static bool _$isFromMe(ChatMessage v) => v.isFromMe;
  static const Field<ChatMessage, bool> _f$isFromMe = Field(
    'isFromMe',
    _$isFromMe,
  );
  static DateTime _$timestamp(ChatMessage v) => v.timestamp;
  static const Field<ChatMessage, DateTime> _f$timestamp = Field(
    'timestamp',
    _$timestamp,
  );
  static String _$senderAlias(ChatMessage v) => v.senderAlias;
  static const Field<ChatMessage, String> _f$senderAlias = Field(
    'senderAlias',
    _$senderAlias,
  );
  static String? _$groupId(ChatMessage v) => v.groupId;
  static const Field<ChatMessage, String> _f$groupId = Field(
    'groupId',
    _$groupId,
    opt: true,
  );
  static String? _$fileName(ChatMessage v) => v.fileName;
  static const Field<ChatMessage, String> _f$fileName = Field(
    'fileName',
    _$fileName,
    opt: true,
  );
  static String? _$filePath(ChatMessage v) => v.filePath;
  static const Field<ChatMessage, String> _f$filePath = Field(
    'filePath',
    _$filePath,
    opt: true,
  );
  static int? _$fileSize(ChatMessage v) => v.fileSize;
  static const Field<ChatMessage, int> _f$fileSize = Field(
    'fileSize',
    _$fileSize,
    opt: true,
  );
  static String? _$fileType(ChatMessage v) => v.fileType;
  static const Field<ChatMessage, String> _f$fileType = Field(
    'fileType',
    _$fileType,
    opt: true,
  );
  static String? _$fileData(ChatMessage v) => v.fileData;
  static const Field<ChatMessage, String> _f$fileData = Field(
    'fileData',
    _$fileData,
    opt: true,
  );
  static bool _$fileDownloaded(ChatMessage v) => v.fileDownloaded;
  static const Field<ChatMessage, bool> _f$fileDownloaded = Field(
    'fileDownloaded',
    _$fileDownloaded,
    opt: true,
    def: false,
  );
  static bool _$hasFile(ChatMessage v) => v.hasFile;
  static const Field<ChatMessage, bool> _f$hasFile = Field(
    'hasFile',
    _$hasFile,
    mode: FieldMode.member,
  );
  static bool _$isImage(ChatMessage v) => v.isImage;
  static const Field<ChatMessage, bool> _f$isImage = Field(
    'isImage',
    _$isImage,
    mode: FieldMode.member,
  );
  static bool _$isVideo(ChatMessage v) => v.isVideo;
  static const Field<ChatMessage, bool> _f$isVideo = Field(
    'isVideo',
    _$isVideo,
    mode: FieldMode.member,
  );
  static Uint8List? _$fileBytes(ChatMessage v) => v.fileBytes;
  static const Field<ChatMessage, Uint8List> _f$fileBytes = Field(
    'fileBytes',
    _$fileBytes,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<ChatMessage> fields = const {
    #id: _f$id,
    #message: _f$message,
    #isFromMe: _f$isFromMe,
    #timestamp: _f$timestamp,
    #senderAlias: _f$senderAlias,
    #groupId: _f$groupId,
    #fileName: _f$fileName,
    #filePath: _f$filePath,
    #fileSize: _f$fileSize,
    #fileType: _f$fileType,
    #fileData: _f$fileData,
    #fileDownloaded: _f$fileDownloaded,
    #hasFile: _f$hasFile,
    #isImage: _f$isImage,
    #isVideo: _f$isVideo,
    #fileBytes: _f$fileBytes,
  };

  static ChatMessage _instantiate(DecodingData data) {
    return ChatMessage(
      id: data.dec(_f$id),
      message: data.dec(_f$message),
      isFromMe: data.dec(_f$isFromMe),
      timestamp: data.dec(_f$timestamp),
      senderAlias: data.dec(_f$senderAlias),
      groupId: data.dec(_f$groupId),
      fileName: data.dec(_f$fileName),
      filePath: data.dec(_f$filePath),
      fileSize: data.dec(_f$fileSize),
      fileType: data.dec(_f$fileType),
      fileData: data.dec(_f$fileData),
      fileDownloaded: data.dec(_f$fileDownloaded),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ChatMessage fromJson(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChatMessage>(map);
  }

  static ChatMessage deserialize(String json) {
    return ensureInitialized().decodeJson<ChatMessage>(json);
  }
}

mixin ChatMessageMappable {
  String serialize() {
    return ChatMessageMapper.ensureInitialized().encodeJson<ChatMessage>(
      this as ChatMessage,
    );
  }

  Map<String, dynamic> toJson() {
    return ChatMessageMapper.ensureInitialized().encodeMap<ChatMessage>(
      this as ChatMessage,
    );
  }

  ChatMessageCopyWith<ChatMessage, ChatMessage, ChatMessage> get copyWith =>
      _ChatMessageCopyWithImpl<ChatMessage, ChatMessage>(
        this as ChatMessage,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ChatMessageMapper.ensureInitialized().stringifyValue(
      this as ChatMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChatMessageMapper.ensureInitialized().equalsValue(
      this as ChatMessage,
      other,
    );
  }

  @override
  int get hashCode {
    return ChatMessageMapper.ensureInitialized().hashValue(this as ChatMessage);
  }
}

extension ChatMessageValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ChatMessage, $Out> {
  ChatMessageCopyWith<$R, ChatMessage, $Out> get $asChatMessage =>
      $base.as((v, t, t2) => _ChatMessageCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ChatMessageCopyWith<$R, $In extends ChatMessage, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? message,
    bool? isFromMe,
    DateTime? timestamp,
    String? senderAlias,
    String? groupId,
    String? fileName,
    String? filePath,
    int? fileSize,
    String? fileType,
    String? fileData,
    bool? fileDownloaded,
  });
  ChatMessageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ChatMessageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChatMessage, $Out>
    implements ChatMessageCopyWith<$R, ChatMessage, $Out> {
  _ChatMessageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChatMessage> $mapper =
      ChatMessageMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? message,
    bool? isFromMe,
    DateTime? timestamp,
    String? senderAlias,
    Object? groupId = $none,
    Object? fileName = $none,
    Object? filePath = $none,
    Object? fileSize = $none,
    Object? fileType = $none,
    Object? fileData = $none,
    bool? fileDownloaded,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (message != null) #message: message,
      if (isFromMe != null) #isFromMe: isFromMe,
      if (timestamp != null) #timestamp: timestamp,
      if (senderAlias != null) #senderAlias: senderAlias,
      if (groupId != $none) #groupId: groupId,
      if (fileName != $none) #fileName: fileName,
      if (filePath != $none) #filePath: filePath,
      if (fileSize != $none) #fileSize: fileSize,
      if (fileType != $none) #fileType: fileType,
      if (fileData != $none) #fileData: fileData,
      if (fileDownloaded != null) #fileDownloaded: fileDownloaded,
    }),
  );
  @override
  ChatMessage $make(CopyWithData data) => ChatMessage(
    id: data.get(#id, or: $value.id),
    message: data.get(#message, or: $value.message),
    isFromMe: data.get(#isFromMe, or: $value.isFromMe),
    timestamp: data.get(#timestamp, or: $value.timestamp),
    senderAlias: data.get(#senderAlias, or: $value.senderAlias),
    groupId: data.get(#groupId, or: $value.groupId),
    fileName: data.get(#fileName, or: $value.fileName),
    filePath: data.get(#filePath, or: $value.filePath),
    fileSize: data.get(#fileSize, or: $value.fileSize),
    fileType: data.get(#fileType, or: $value.fileType),
    fileData: data.get(#fileData, or: $value.fileData),
    fileDownloaded: data.get(#fileDownloaded, or: $value.fileDownloaded),
  );

  @override
  ChatMessageCopyWith<$R2, ChatMessage, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChatMessageCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

