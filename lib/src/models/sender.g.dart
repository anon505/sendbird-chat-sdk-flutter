// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sender.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sender _$SenderFromJson(Map<String, dynamic> json) {
  return Sender(
    isBlockedByMe: json['is_blocked_by_me'] as bool,
    role: _$enumDecodeNullable(_$RoleEnumMap, json['role'],
        unknownValue: Role.none),
    userId: json['user_id'] as String,
    nickname: json['nickname'] as String,
    profileUrl: json['profile_url'] as String,
    isOnline: json['is_online'] as bool,
    lastSeenAt: json['last_seen_at'] as int,
    preferredLanguages: (json['preferred_languages'] as List)
        ?.map((e) => e as String)
        ?.toList(),
    friendDiscoveryKey: json['friend_discovery_key'] as String,
    friendName: json['friend_name'] as String,
    discoveryKeys:
        (json['discovery_keys'] as List)?.map((e) => e as String)?.toList(),
    metaData: (json['meta_data'] as Map<String, dynamic>)?.map(
          (k, e) => MapEntry(k, e as String),
        ) ??
        {},
    requireAuth: json['require_auth_for_profile_image'] as bool,
  )..isActive = json['is_active'] as bool;
}

Map<String, dynamic> _$SenderToJson(Sender instance) => <String, dynamic>{
      'user_id': instance.userId,
      'nickname': instance.nickname,
      'profile_url': instance.profileUrl,
      'is_online': instance.isOnline,
      'last_seen_at': instance.lastSeenAt,
      'is_active': instance.isActive,
      'preferred_languages': instance.preferredLanguages,
      'friend_discovery_key': instance.friendDiscoveryKey,
      'friend_name': instance.friendName,
      'discovery_keys': instance.discoveryKeys,
      'meta_data': instance.metaData,
      'require_auth_for_profile_image': instance.requireAuth,
      'is_blocked_by_me': instance.isBlockedByMe,
      'role': _$RoleEnumMap[instance.role],
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$RoleEnumMap = {
  Role.none: 'none',
  Role.chat_operator: 'operator',
};