import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:uuid/uuid.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  const User({
    this.email = '',
    this.accessToken = '',
    });

  static const empty = User();

  final String email;
  final String accessToken;

  String get id => getTokenPayload()['sub'];
  String get emailNormalised  => email.toUpperCase();

  Map<String, dynamic> getTokenPayload() {
    return Jwt.parseJwt(accessToken);
  }

  @override
  List<Object> get props => [email, accessToken];

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
