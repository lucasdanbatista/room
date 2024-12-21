import 'package:json_annotation/json_annotation.dart';
import 'package:room/room.dart';

part 'person.g.dart';

@Entity()
@JsonSerializable()
class Person with $PersonEntity {
  @PrimaryKey()
  final int id;

  @Column()
  final String name;

  Person({
    required this.id,
    required this.name,
  });

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  Map<String, dynamic> toJson() => _$PersonToJson(this);
}
