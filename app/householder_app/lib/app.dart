import 'package:flutter/material.dart';
import 'package:householder_design_system/theme/app_theme.dart';

import 'core/core.dart';

class ItersapiensHouseholderApp extends StatefulWidget {
  const ItersapiensHouseholderApp({super.key});

  @override
  State<ItersapiensHouseholderApp> createState() =>
      _ItersapiensHouseholderAppState();
}

class _ItersapiensHouseholderAppState extends State<ItersapiensHouseholderApp> {
  late final _router = createAppRouter(getIt<SessionNotifier>());

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Itersapiens',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: _router,
    );
  }
}
