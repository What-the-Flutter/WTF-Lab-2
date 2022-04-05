import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';

import '../widgets/home_widget.dart';

enum _SupportState {
  unknown,
  supported,
  unsupported,
}

class BioAuth extends StatefulWidget {
  const BioAuth({Key? key}) : super(key: key);

  @override
  State<BioAuth> createState() => _BioAuthState();
}

class _BioAuthState extends State<BioAuth> {
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    auth.isDeviceSupported().then(
          (isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
    if (_supportState == _SupportState.supported) _checkBiometrics();
    if (_canCheckBiometrics != null && _canCheckBiometrics == true) {
      _authenticateWithBiometrics();
    }
  }

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    late List<BiometricType> avalibleBio;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
      if (canCheckBiometrics) {
        avalibleBio = await auth.getAvailableBiometrics();
      }
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _availableBiometrics = avalibleBio;
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _authenticateWithBiometrics() async {
    var authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
          localizedReason:
              'Scan your fingerprint (or face or whatever) to authenticate',
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) return;

    final message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
      (_authorized == 'Authorized')
          ? Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: ((context) => const Home()),
              ),
            )
          // ignore: unnecessary_statements
          : null;
    });
  }

  void _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }

  @override
  Widget build(BuildContext context) {
    final _heigth = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Container(
              decoration: BoxDecoration(
                  image: const DecorationImage(
                    opacity: 0.5,
                    image: AssetImage('assets/auth_back.jpg'),
                    fit: BoxFit.fitWidth,
                  ),
                  color: Colors.black,
                  border: Border.all(width: 0)),
              height: _heigth * 0.3,
            ),
            Container(
              width: double.infinity,
              child: Center(
                child: Text(
                  'Welcome Back!',
                  style: GoogleFonts.bebasNeue(
                    color: Colors.white,
                    fontSize: 40,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.7),
                    Theme.of(context).primaryColor,
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                border: Border.all(
                  width: 0,
                  color: Theme.of(context).primaryColor,
                ),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(75),
                ),
              ),
              height: _heigth * 0.3,
            ),
            Container(
              margin: EdgeInsets.only(
                  top: _heigth * 0.2,
                  left: _width * 0.7),
            ),
            Container(
              child: _authButton(context),
              margin: EdgeInsets.only(
                  top: _heigth * 0.3),
              decoration: BoxDecoration(
                  image: const DecorationImage(
                    opacity: 0.1,
                    image: AssetImage('assets/auth_back.jpg'),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(
                    width: 0,
                  ),
                  color: Colors.black,
                  borderRadius:
                      const BorderRadius.only(topLeft: Radius.circular(75))),
              width: double.infinity,
              height: _heigth * 0.7,
            )
          ],
        ),
      ),
    );
  }

  Widget _authButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_supportState == _SupportState.supported &&
            _authorized == 'Not Authorized') {
          _authenticateWithBiometrics();
        } else if (_supportState == _SupportState.supported &&
            _authorized == 'Authorized') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
          );
        }
      },
      child: Icon(
        Icons.fingerprint,
        size: MediaQuery.of(context).size.width * 0.2,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
