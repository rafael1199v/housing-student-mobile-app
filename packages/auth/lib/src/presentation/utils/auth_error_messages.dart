import '../../l10n/gen/auth_localizations.dart';

String authErrorMessage(AuthLocalizations l10n, String code) {
  switch (code) {
    case 'invalid.credentials':
      return l10n.errInvalidCredentials;
    case 'email.not.confirmed':
      return l10n.errEmailNotConfirmed;
    case 'invalid.user.id':
      return l10n.errInvalidUserId;
    case 'refresh.token.expired':
    case 'unauthorized':
      return l10n.errUnauthorized;
    case 'validation.failed':
      return l10n.errValidationFailed;
    case 'email.already.exists':
    case 'email.already.registered':
    case 'user.already.exists':
      return l10n.errEmailAlreadyExists;
    case 'google.auth.failed':
    case 'google.invalid.token':
      return l10n.errGoogleAuthFailed;
    case 'confirm.email.failed':
    case 'invalid.token':
    case 'invalid.confirmation.token':
      return l10n.errInvalidConfirmationToken;
    case 'email.already.confirmed':
      return l10n.errEmailAlreadyConfirmed;
    case 'rate.limited':
      return l10n.errTooManyAttempts;
    case 'network.error':
      return l10n.errNetwork;
    case 'server.error':
      return l10n.errServer;
    default:
      return l10n.errUnexpected;
  }
}
