String authErrorMessage(String code) {
  switch (code) {
    case 'invalid.credentials':
      return 'Wrong email or password.';
    case 'email.not.confirmed':
      return 'Please confirm your email before signing in.';
    case 'invalid.user.id':
      return 'We could not find your account.';
    case 'refresh.token.expired':
    case 'unauthorized':
      return 'Your session expired. Please sign in again.';
    case 'validation.failed':
      return 'Please check the highlighted fields.';
    case 'email.already.exists':
    case 'email.already.registered':
    case 'user.already.exists':
      return 'An account with this email already exists.';
    case 'google.auth.failed':
    case 'google.invalid.token':
      return 'Google sign-in failed. Please try again.';
    case 'confirm.email.failed':
    case 'invalid.token':
    case 'invalid.confirmation.token':
      return 'Invalid or expired confirmation token. Check the link or token.';
    case 'email.already.confirmed':
      return 'This email is already confirmed. You can sign in.';
    case 'rate.limited':
      return 'Too many attempts. Please wait a moment and try again.';
    case 'network.error':
      return 'No connection. Check your network and try again.';
    case 'server.error':
      return 'Something went wrong on our side. Please try again later.';
    default:
      return 'Unexpected error. Please try again.';
  }
}
