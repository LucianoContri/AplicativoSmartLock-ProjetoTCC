class AuthException implements Exception {
  static const Map<String, String> errors = {
    'EMAIL_EXISTS': 'E-mail já cadastrado.',
    'OPERATION_NOT_ALLOWED': 'Operação não permitida!',
    'TOO_MANY_ATTEMPTS_TRY_LATER': 'Muitas tentativas, tente mais tarde.',
    'EMAIL_NOT_FOUND': 'E-mail não foi encontrado.',
    'INVALID_PASSWORD': 'Senha incorreta.',
    'USER_DISABLED': 'Conta desabilitada.',
    'WEAK_PASSWORD': 'Senha minima de 6 caracteres',
  };

  final String key;

  AuthException(this.key);

  @override
  String toString() {
    return errors[key] ?? 'Um erro inesperado foi encontrado';
  }
}
