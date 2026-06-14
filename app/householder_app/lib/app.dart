import 'package:flutter/material.dart';
import 'package:housing_design_system/housing_design_system.dart';

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
      theme: AppTheme.householder,
      routerConfig: _router,
    );
  }
}
