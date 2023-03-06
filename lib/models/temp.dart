// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
//
// import 'models.dart';
//
// class ConversationModel {
//   String cid;
//   String conName;
//   String? image;
//   bool? isFriend;
//   String? lastMes;
//   Timestamp? lastTime;
//   List<MessageModel>? messages;
//   ConversationModel({
//     required this.cid,
//     required this.conName,
//     this.image,
//     required this.isFriend,
//     this.lastMes,
//     required this.lastTime,
//     this.messages,
//   });
//
//
//
//
//
//   ConversationModel copyWith({
//     String? cid,
//     String? conName,
//     String? image,
//     bool? isFriend,
//     String? lastMes,
//     Timestamp? lastTime,
//     bool? isGroup,
//     String? adminId,
//     List<UserModel>? members,
//     List<MessageModel>? messages,
//   }) {
//     return ConversationModel(
//       cid: cid ?? this.cid,
//       conName: conName ?? this.conName,
//       image: image ?? this.image,
//       isFriend: isFriend ?? this.isFriend,
//       lastMes: lastMes ?? this.lastMes,
//       lastTime: lastTime ?? this.lastTime,
//       messages: messages ?? this.messages,
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'cid': cid,
//       'conName': conName,
//       'image': image,
//       'isFriend': isFriend,
//       'lastMes': lastMes,
//       'lastTime': lastTime,
//       'messages': messages??[],
//     };
//   }
//
//   factory ConversationModel.fromMap(Map<String, dynamic> map) {
//     return ConversationModel(
//       cid: map['cid'] as String,
//       conName: map['conName'] as String,
//       image: map['image'] != null ? map['image'] as String : null,
//       isFriend: map['isFriend'] != null ? map['isFriend'] as bool : null,
//       lastMes: map['lastMes'] != null ? map['lastMes'] as String : null,
//       lastTime: map['lastTime'],
//       messages: map['messages'],
//     );
//   }
//
//   String toJson() => json.encode(toMap());
//
//   factory ConversationModel.fromJson(String source) => ConversationModel.fromMap(json.decode(source) as Map<String, dynamic>);
//
//   @override
//   String toString() {
//     return 'ConversationModel(cid: $cid, conName: $conName, image: $image, isFriend: $isFriend, lastMes: $lastMes, lastTime: $lastTime, messages: $messages)';
//   }
//
//   @override
//   bool operator ==(covariant ConversationModel other) {
//     if (identical(this, other)) return true;
//
//     return
//       other.cid == cid &&
//           other.conName == conName &&
//           other.image == image &&
//           other.isFriend == isFriend &&
//           other.lastMes == lastMes &&
//           other.lastTime == lastTime &&
//           listEquals(other.messages, messages);
//   }
//
//   @override
//   int get hashCode {
//     return cid.hashCode ^
//     conName.hashCode ^
//     image.hashCode ^
//     isFriend.hashCode ^
//     lastMes.hashCode ^
//     lastTime.hashCode ^
//     messages.hashCode;
//   }
// }
