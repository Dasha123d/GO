import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:tproger_mobile_app/src/services/url_launcher/url_launcher_service.dart';
import 'package:url_launcher/url_launcher_string.dart';

@Singleton(as: UrlLauncherService)
class UrlLauncherServiceImpl implements UrlLauncherService {
  final Logger _logger;

  UrlLauncherServiceImpl(this._logger);

  @override
  Future<void> launch(String url) async {
    final isOk = await launchUrlString(url, mode: LaunchMode.externalApplication);

    if (!isOk) {
      _logger.e('Cannot open link="$url"');
    }
  }
}