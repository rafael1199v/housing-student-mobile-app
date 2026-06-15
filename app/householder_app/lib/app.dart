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
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>.value(value: getIt<ThemeCubit>()),
        BlocProvider<LocaleCubit>.value(value: getIt<LocaleCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return BlocBuilder<LocaleCubit, Locale>(
            builder: (context, locale) {
              return MaterialApp.router(
                title: 'Itersapiens',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.householder,
                darkTheme: AppTheme.householderDark,
                themeMode: themeMode,
                locale: locale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                routerConfig: _router,
              );
            },
          );
        },
      ),
    );
  }
}
