import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:tproger_mobile_app/src/services/di_configuration/configure_injectable.config.dart';

@InjectableInit(
  initializerName: r'$configureInjectable',
  preferRelativeImports: false,
)
GetIt configureInjectable() => $configureInjectable(GetIt.instance);
