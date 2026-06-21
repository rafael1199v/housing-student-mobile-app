import '../../domain/entities/credentials.dart';
import 'credentials_dto.dart';

extension CredentialsDtoMapper on CredentialsDto {
  Credentials toEntity() => Credentials(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
}
