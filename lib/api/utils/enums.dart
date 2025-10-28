enum HttpErrorCodes {
  accountStatusError('AccountStatusError'),
  mobileNumberNotVerifiedError('mobileNumberNotVerifiedError');

  final String text;
  const HttpErrorCodes(this.text);
}
