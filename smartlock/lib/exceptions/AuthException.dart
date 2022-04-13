class AuthException implements Exception {
  static const Map<String, String> errors = {
    'EMAIL_EXISTS': 'E-mail já cadastrado.',
    'OPERATION_NOT_ALLOWED': 'Operação não permitida!',
    'TOO_MANY_ATTEMPTS_TRY_LATER': 'Muitos erros, tente mais tarde.',
    'EMAIL_NOT_FOUND': 'E-mail não foi encontrado.',
    'INVALID_PASSWORD': 'Senha incorreta.',
    'USER_DISABLED': 'Conta desabilitada.',
  };

  final String key;

  AuthException(this.key);

  @override
  String toString() {
    // TODO: implement toString
    return errors[key] ?? 'Algo de errado não está certo';
  }
}
