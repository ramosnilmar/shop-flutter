class AuthException implements Exception {
  static const Map<String, String> errors = {
    'EMAIL_EXISTS': 'Este endereço de e-mail já está em uso.',
    'OPERATION_NOT_ALLOWED':
        'O login por senha está desativado para este projeto.',
    'TOO_MANY_ATTEMPTS_TRY_LATER':
        'Bloqueamos todas as solicitações deste dispositivo devido a atividade incomum. Tente novamente mais tarde.',
    'INVALID_LOGIN_CREDENTIALS': 'Email / Senha não encontrados.',
    'INVALID_PASSWORD': 'Email / Senha não encontrados.',
    'USER_DISABLED': 'Esta conta de usuário foi desativada.'
  };

  final String key;

  AuthException(this.key);

  @override
  String toString() {
    if (errors.containsKey(key)) {
      return errors[key]!;
    } else {
      return 'Ocorreu um erro inesperado.';
    }
  }
}
