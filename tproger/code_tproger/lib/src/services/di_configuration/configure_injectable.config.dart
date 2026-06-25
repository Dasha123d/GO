// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i5;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:logger/logger.dart' as _i8;
import 'package:tproger_mobile_app/src/services/app_localization_service.dart'
    as _i3;
import 'package:tproger_mobile_app/src/services/article_list/article_list_loader.dart'
    as _i15;
import 'package:tproger_mobile_app/src/services/article_list/article_list_parser.dart'
    as _i4;
import 'package:tproger_mobile_app/src/services/article_list/article_list_service.dart'
    as _i16;
import 'package:tproger_mobile_app/src/services/di_configuration/register_module.dart'
    as _i6;
import 'package:tproger_mobile_app/src/services/http_service.dart' as _i7;
import 'package:tproger_mobile_app/src/services/overlay_service.dart' as _i9;
import 'package:tproger_mobile_app/src/services/reaction_service.dart' as _i10;
import 'package:tproger_mobile_app/src/services/redux/middleware_service.dart'
    as _i17;
import 'package:tproger_mobile_app/src/services/redux/reducer_service.dart'
    as _i11;
import 'package:tproger_mobile_app/src/services/redux/store_factory.dart'
    as _i18;
import 'package:tproger_mobile_app/src/services/url_launcher/url_launcher_service.dart'
    as _i12;
import 'package:tproger_mobile_app/src/services/url_launcher/url_launcher_service_impl.dart'
    as _i13;
import 'package:tproger_mobile_app/src/services/view_count_service.dart'
    as _i14; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $configureInjectable(
  _i1.GetIt get, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  final registerModule = _$RegisterModule();
  gh.singleton<_i3.AppLocalizationService>(_i3.AppLocalizationService());
  gh.singleton<_i4.ArticleListParser>(_i4.ArticleListParser());
  gh.singleton<_i5.Dio>(
    registerModule.dio,
    dispose: _i6.disposeDio,
  );
  gh.singleton<_i7.HttpService>(_i7.HttpService(get<_i5.Dio>()));
  gh.singleton<_i8.Logger>(
    registerModule.logger,
    dispose: _i6.disposeLogger,
  );
  gh.singleton<_i9.OverlayService>(_i9.OverlayService());
  gh.singleton<_i10.ReactionService>(_i10.ReactionService());
  gh.singleton<_i11.ReducerService>(_i11.ReducerService());
  gh.singleton<_i12.UrlLauncherService>(
      _i13.UrlLauncherServiceImpl(get<_i8.Logger>()));
  gh.singleton<_i14.ViewCountService>(_i14.ViewCountService());
  gh.singleton<_i15.ArticleListLoader>(_i15.ArticleListLoader(
    get<_i4.ArticleListParser>(),
    get<_i7.HttpService>(),
  ));
  gh.singleton<_i16.ArticleListService>(
      _i16.ArticleListService(get<_i15.ArticleListLoader>()));
  gh.singleton<_i17.MiddlewareService>(_i17.MiddlewareService(
    get<_i16.ArticleListService>(),
    get<_i12.UrlLauncherService>(),
    get<_i8.Logger>(),
  ));
  gh.singleton<_i18.StoreFactory>(_i18.StoreFactory(
    get<_i11.ReducerService>(),
    get<_i17.MiddlewareService>(),
  ));
  return get;
}

class _$RegisterModule extends _i6.RegisterModule {}
