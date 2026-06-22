import '../../domain/entities/google_auth_result.dart';
import 'credentials_mapper.dart';
import 'google_auth_response_dto.dart';

extension GoogleAuthResponseMapper on GoogleAuthResponseDto {
  GoogleAuthResult toEntity() => GoogleAuthResult(
        isNewUser: isNewUser,
        credentials: credentials?.toEntity(),
      );
}
