import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthenticationService {
  final _auth = LocalAuthentication();
  bool isProtectionEnabled = true;

  bool isAuthenticated = false;

  Future<void> authenticate() async {
    if (isProtectionEnabled) {
      try {
        isAuthenticated = await _auth.authenticate(
          localizedReason: 'authenticate to access',
        );
      } on PlatformException catch (e) {
        print(e);
      }
    }
  }
}
