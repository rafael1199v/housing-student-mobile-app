import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return BlocProvider<ThemeCubit>.value(
      value: getIt<ThemeCubit>(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'Itersapiens',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.householder,
            darkTheme: AppTheme.householderDark,
            themeMode: themeMode,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
