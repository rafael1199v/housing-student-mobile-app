import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app.dart';
import 'core/config/app_config.dart';
import 'core/config/web_runtime_config.dart';
import 'core/di/injector.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await applyWebRuntimeConfig(
    mapsKey: AppConfig.mapsWebApiKeyOrNull,
    googleClientId: AppConfig.googleWebClientIdOrNull,
  );
  await configureDependencies();
  runApp(const ItersapiensHouseholderApp());
}
