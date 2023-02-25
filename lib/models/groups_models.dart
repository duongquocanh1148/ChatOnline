// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'models.dart';

class GroupModel {
  String cid;
  String conName;
  String? image;
  String? lastMes;
  Timestamp? lastTime;
  bool? isGroup;
  String adminId;
  List<UserModel>? members;
  List<MessageModel>? messages;
  GroupModel({
    required this.cid,
    required this.conName,
    this.image,
    this.lastMes,
    this.lastTime,
    this.isGroup,
    required this.adminId,
    this.members,
    this.messages,
  });

  GroupModel copyWith({
    String? cid,
    String? conName,
    String? image,
    String? lastMes,
    Timestamp? lastTime,
    bool? isGroup,
    String? adminId,
    List<UserModel>? members,
    List<MessageModel>? messages,
  }) {
    return GroupModel(
      cid: cid ?? this.cid,
      conName: conName ?? this.conName,
      image: image ?? this.image,
      lastMes: lastMes ?? this.lastMes,
      lastTime: lastTime ?? this.lastTime,
      isGroup: isGroup ?? this.isGroup,
      adminId: adminId ?? this.adminId,
      members: members ?? this.members,
      messages: messages ?? this.messages,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cid': cid,
      'conName': conName,
      'image': image,
      'lastMes': lastMes,
      'lastTime': lastTime,
      'isGroup': isGroup,
      'adminId': adminId,
      'members': members??[],
      'messages': messages??[],
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      cid: map['cid'] as String,
      conName: map['conName'] as String,
      image: map['image'] != null ? map['image'] as String : null,
      lastMes: map['lastMes'] != null ? map['lastMes'] as String : null,
      lastTime: map['lastTime'],
      isGroup: map['isGroup'] != null ? map['isGroup'] as bool : null,
      adminId: map['adminId'] as String,
      members: map['members'],
      messages: map['messages'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupModel.fromJson(String source) => GroupModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GroupModel(cid: $cid, conName: $conName, image: $image, lastMes: $lastMes, lastTime: $lastTime, isGroup: $isGroup, adminId: $adminId, members: $members, messages: $messages)';
  }

  @override
  bool operator ==(covariant GroupModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.cid == cid &&
      other.conName == conName &&
      other.image == image &&
      other.lastMes == lastMes &&
      other.lastTime == lastTime &&
      other.isGroup == isGroup &&
      other.adminId == adminId &&
      listEquals(other.members, members) &&
      listEquals(other.messages, messages);
  }

  @override
  int get hashCode {
    return cid.hashCode ^
      conName.hashCode ^
      image.hashCode ^
      lastMes.hashCode ^
      lastTime.hashCode ^
      isGroup.hashCode ^
      adminId.hashCode ^
      members.hashCode ^
      messages.hashCode;
  }
}
