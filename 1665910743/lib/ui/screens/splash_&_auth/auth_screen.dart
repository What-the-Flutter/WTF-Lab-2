import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottie/lottie.dart';

import '../../theme/theme_cubit/theme_cubit.dart';
import '../home/cubit/home_cubit.dart';
import '../home/home_widget.dart';
import 'cubit/auth_cubit.dart';

class BioAuth extends StatefulWidget {
  final AuthCubit authCubit;

  const BioAuth({
    Key? key,
    required this.authCubit,
  }) : super(key: key);

  @override
  State<BioAuth> createState() => _BioAuthState();
}

class _BioAuthState extends State<BioAuth> with TickerProviderStateMixin {
  final LocalAuthentication auth = LocalAuthentication();
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    auth.isDeviceSupported().then(
      (isSupported) {
        isSupported
            ? widget.authCubit.supportState(SupportState.supported)
            : widget.authCubit.supportState(SupportState.unsupported);
      },
    );
    if (widget.authCubit.state.supportState == SupportState.supported) {
      _checkBiometrics();
    }
    if (widget.authCubit.state.canCheckBiometrics != null &&
        widget.authCubit.state.canCheckBiometrics == true) {
      _authenticateWithBiometrics();
    }
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    Future.delayed(const Duration(seconds: 1))
        .then((_) => _controller.forward());
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

    widget.authCubit.availableBiometrics(avalibleBio);
    widget.authCubit.canCheckBiometrics(canCheckBiometrics);
  }

  Future<void> _authenticateWithBiometrics() async {
    var authenticated = false;
    try {
      widget.authCubit.isAuthenticating(true);
      widget.authCubit.authorized('Authenticating');
      authenticated = await auth.authenticate(
          localizedReason:
              'Scan your fingerprint (or face or whatever) to authenticate',
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true);
      widget.authCubit.isAuthenticating(false);
      widget.authCubit.authorized('Authenticating');
    } on PlatformException catch (e) {
      print(e);
      widget.authCubit.isAuthenticating(false);
      widget.authCubit.authorized('Error - ${e.message}');

      return;
    }
    if (!mounted) return;

    final message = authenticated ? 'Authorized' : 'Not Authorized';
    widget.authCubit.authorized(message);

    if (message == 'Authorized') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: ((context) => Home(
                homeCubit: context.read<HomeCubit>(),
                themeCubit: context.read<ThemeCubit>(),
              )),
        ),
      );
    }
  }

  void _cancelAuthentication() async {
    await auth.stopAuthentication();
    widget.authCubit.isAuthenticating(false);
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
                    opacity: 0.1,
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
              margin: EdgeInsets.only(top: _heigth * 0.2, left: _width * 0.7),
            ),
            Container(
              child: _authButton(context),
              margin: EdgeInsets.only(top: _heigth * 0.3),
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
    return BlocBuilder<AuthCubit, AuthState>(
      bloc: widget.authCubit,
      builder: ((context, state) => GestureDetector(
            onTap: () {
              if (state.supportState == SupportState.supported &&
                  state.authorized == 'Not Authorized') {
                _authenticateWithBiometrics();
              } else if (state.supportState == SupportState.supported &&
                  state.authorized == 'Authorized') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Home(
                            homeCubit: context.read<HomeCubit>(),
                            themeCubit: context.read<ThemeCubit>(),
                          )),
                );
              }
            },
            child: Center(
              child: Container(
                child: Lottie.asset(
                  'assets/biometric.json',
                  controller: _controller,
                  repeat: false,
                  width: 200,
                  height: 200,
                ),
              ),
            ),
          )),
    );
  }
}
