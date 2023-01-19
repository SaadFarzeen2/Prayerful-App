import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PrayedModel {
  String image;
  String uid;
  String time;
  PrayedModel({
    required this.image,
    required this.uid,
    required this.time,
  });

  // PrayedModel copyWith({
  //   String? image,
  //   String? uid,
  //   String? time,
  // }) {
  //   return PrayedModel(
  //     image: image ?? this.image,
  //     uid: uid ?? this.uid,
  //     time: time ?? this.time,
  //   );
  // }

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'image': image,
  //     'uid': uid,
  //     'time': time,
  //   };
  // }

  // factory PrayedModel.fromMap(Map<String, dynamic> map) {
  //   return PrayedModel(
  //     image: map['image'] as String,
  //     uid: map['uid'] as String,
  //     time: map['time'] as String,
  //   );
  // }

  // String toJson() => json.encode(toMap());

  // factory PrayedModel.fromJson(String source) =>
  //     PrayedModel.fromMap(json.decode(source) as Map<String, dynamic>);

  // @override
  // String toString() => 'PrayedModel(image: $image, uid: $uid, time: $time)';

  // @override
  // bool operator ==(covariant PrayedModel other) {
  //   if (identical(this, other)) return true;

  //   return other.image == image && other.uid == uid && other.time == time;
  // }

  // @override
  // int get hashCode => image.hashCode ^ uid.hashCode ^ time.hashCode;
}
