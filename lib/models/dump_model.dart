// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';
//
// class DumpModel {
//   final String name;
//   final String age;
//   DumpModel({
//     required this.name,
//     required this.age,
//   });
//
//   DumpModel copyWith({
//     String? name,
//     String? age,
//   }) {
//     return DumpModel(
//       name: name ?? this.name,
//       age: age ?? this.age,
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'name': name,
//       'age': age,
//     };
//   }
//
//   factory DumpModel.fromMap(Map<String, dynamic> map) {
//     return DumpModel(
//       name: map['name'] as String,
//       age: map['age'] as String,
//     );
//   }
//
//   String toJson() => json.encode(toMap());
//
//   factory DumpModel.fromJson(String source) => DumpModel.fromMap(json.decode(source) as Map<String, dynamic>);
//
//   @override
//   String toString() => 'DumpModel(name: $name, age: $age)';
//
//   @override
//   bool operator ==(covariant DumpModel other) {
//     if (identical(this, other)) return true;
//
//     return
//       other.name == name &&
//       other.age == age;
//   }
//
//   @override
//   int get hashCode => name.hashCode ^ age.hashCode;
// }
