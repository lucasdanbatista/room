import 'package:json_annotation/json_annotation.dart';
import 'package:room/room.dart';

part 'company.g.dart';

@Entity()
@JsonSerializable()
class Company with $CompanyEntity {
  @PrimaryKey()
  final String document;

  @Column()
  String? name;

  Company({
    required this.document,
    this.name,
  });

  factory Company.fromJson(Map<String, dynamic> json) =>
      _$CompanyFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyToJson(this);
}
