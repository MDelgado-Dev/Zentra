import 'package:local_auth/local_auth.dart';

class SecurityService {
  SecurityService({LocalAuthentication? auth})
    : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  Future<bool> canCheckBiometrics() => _auth.canCheckBiometrics;

  Future<bool> authenticate() {
    return _auth.authenticate(
      localizedReason: 'Unlock Zentra',
      options: const AuthenticationOptions(biometricOnly: true),
    );
  }
}
