import 'package:get_it/get_it.dart';

import 'local_auth.dart';

GetIt locator = GetIt.I;

void setupLocator() {
  locator.registerLazySingleton(LocalAuthenticationService.new);
}
