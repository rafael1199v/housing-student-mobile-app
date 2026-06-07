import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/injector.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const ItersapiensHouseholderApp());
}
