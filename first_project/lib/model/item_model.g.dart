// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Item _$$_ItemFromJson(Map<String, dynamic> json) => _$_Item(
      id: json['id'] as String?,
      url: json['url'] as String,
      comment: json['comment'] as String,
      email: json['email'] as String,
      hash: json['hash'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: const DateTimeTimestampConverter()
          .fromJson(json['createdAt'] as Timestamp),
    );

Map<String, dynamic> _$$_ItemToJson(_$_Item instance) => <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'comment': instance.comment,
      'email': instance.email,
      'hash': instance.hash,
      'isCompleted': instance.isCompleted,
      'createdAt':
          const DateTimeTimestampConverter().toJson(instance.createdAt),
    };
