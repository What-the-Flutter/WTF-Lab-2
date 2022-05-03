import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import '../data/shared_preferences_provider.dart';

class LocalAuthenticationService {
  final _auth = LocalAuthentication();
  final bool _isProtectionEnabled = SharedPreferencesProvider().fetchLocalAuth();

  bool isAuthenticated = false;

  Future<void> authenticate() async {
    if (_isProtectionEnabled) {
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
